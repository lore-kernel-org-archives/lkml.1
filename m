Return-Path: <linux-kernel-owner+w=401wt.eu-S1946640AbXBIROK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946640AbXBIROK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946638AbXBIROK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:14:10 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:46103 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946640AbXBIROJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:14:09 -0500
Date: Fri, 9 Feb 2007 12:14:05 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Len Brown <lenb@kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [PATCH 6c/10] lguest: the guest code
In-Reply-To: <200702091206.31797.lenb@kernel.org>
Message-ID: <Pine.LNX.4.64.0702091212360.9007@d.namei>
References: <1171012296.2718.26.camel@localhost.localdomain>
 <1171018590.2718.60.camel@localhost.localdomain> <1171018674.2718.63.camel@localhost.localdomain>
 <200702091206.31797.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="537530981-931463441-1171041245=:9007"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--537530981-931463441-1171041245=:9007
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 9 Feb 2007, Len Brown wrote:

> On Friday 09 February 2007 05:57, Rusty Russell wrote:
> 
> > +#ifdef CONFIG_ACPI
> > +       acpi_disabled = 1;
> > +       acpi_ht = 0;
> > +#endif
> 
> If this is hard-coded to have ACPI disabled, why isn't it enforced at build-time?

This is being disabled in the guest kernel only.  The host and guest 
kernels are expected to be the same build.



- James
-- 
James Morris
<jmorris@namei.org>
--537530981-931463441-1171041245=:9007--
