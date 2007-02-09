Return-Path: <linux-kernel-owner+w=401wt.eu-S2992461AbXBIRva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992461AbXBIRva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXBIRva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:51:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:46706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992461AbXBIRv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:51:29 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 6c/10] lguest: the guest code
Date: Fri, 9 Feb 2007 12:49:57 -0500
User-Agent: KMail/1.9.5
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       virtualization <virtualization@lists.osdl.org>
References: <1171012296.2718.26.camel@localhost.localdomain> <200702091206.31797.lenb@kernel.org> <Pine.LNX.4.64.0702091212360.9007@d.namei>
In-Reply-To: <Pine.LNX.4.64.0702091212360.9007@d.namei>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702091249.58204.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 12:14, James Morris wrote:
> On Fri, 9 Feb 2007, Len Brown wrote:
> 
> > On Friday 09 February 2007 05:57, Rusty Russell wrote:
> > 
> > > +#ifdef CONFIG_ACPI
> > > +       acpi_disabled = 1;
> > > +       acpi_ht = 0;
> > > +#endif
> > 
> > If this is hard-coded to have ACPI disabled, why isn't it enforced at build-time?
> 
> This is being disabled in the guest kernel only.  The host and guest 
> kernels are expected to be the same build.

Okay, but better to use disable_acpi()
indeed, since this would be the first code not already inside CONFIG_ACPI
to invoke disable_acpi(), we could define the inline as empty and you could
then scratch the #ifdef too.

cheers,
-Len
