Return-Path: <linux-kernel-owner+w=401wt.eu-S2992436AbXBIRIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992436AbXBIRIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992446AbXBIRIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:08:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:54392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992436AbXBIRIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:08:04 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 6c/10] lguest: the guest code
Date: Fri, 9 Feb 2007 12:06:31 -0500
User-Agent: KMail/1.9.5
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       virtualization <virtualization@lists.osdl.org>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171018590.2718.60.camel@localhost.localdomain> <1171018674.2718.63.camel@localhost.localdomain>
In-Reply-To: <1171018674.2718.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702091206.31797.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 05:57, Rusty Russell wrote:

> +#ifdef CONFIG_ACPI
> +       acpi_disabled = 1;
> +       acpi_ht = 0;
> +#endif

If this is hard-coded to have ACPI disabled, why isn't it enforced at build-time?

thanks,
-Len
