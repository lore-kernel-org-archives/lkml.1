Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbXKNOT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbXKNOT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXKNOTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:19:20 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1388 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbXKNOTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:19:20 -0500
Subject: Re: [PATCH] - [12/15] - remove defconfig ptr comparisons to 0 -
	include/asm-x86
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.0.9999.0711141055050.3265@localhost.localdomain>
References: <1195005932.5163.98.camel@localhost>
	 <alpine.LFD.0.9999.0711141055050.3265@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 06:19:05 -0800
Message-Id: <1195049945.5163.138.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-14 at 11:54 +0100, Thomas Gleixner wrote:
> can you please CC the relevant maintainers on patches ?

I do try.

I also happen to have a series of patches to MAINTAINERS
and a scripts/get_maintainer.pl that do exactly that.
Maybe a future version might use it.

cheers,  Joe

> > diff --git a/include/asm-x86/mach-es7000/mach_mpparse.h b/include/asm-x86/mach-es7000/mach_mpparse.h
> > index 8aa1054..a1dd66f 100644
> > --- a/include/asm-x86/mach-es7000/mach_mpparse.h
> > +++ b/include/asm-x86/mach-es7000/mach_mpparse.h
> > @@ -29,7 +29,7 @@ extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
> >  static inline int es7000_check_dsdt(void)
> >  {
> >  	struct acpi_table_header header;
> > -	memcpy(&header, 0, sizeof(struct acpi_table_header));
> > +	memcpy(&header, (void *)0, sizeof(struct acpi_table_header));
> >  	acpi_get_table_header(ACPI_SIG_DSDT, 0, &header);
> >  	if (!strncmp(header.oem_id, "UNISYS", 6))
> >  		return 1;


