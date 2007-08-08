Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXHHHVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXHHHVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760763AbXHHHUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:20:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:57125 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766AbXHHHUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:20:11 -0400
Subject: Re: [PATCH] sonypi: Fix initialization warning
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>,
       Ben Collins <bcollins@ubuntu.com>, linux-acpi@vger.kernel.org,
       Stelian Pop <stelian@popies.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200708071507.33141.lenb@kernel.org>
References: <46B61F70.90005@student.ltu.se>
	 <1186343443.3858.46.camel@fanta4.site> <46B62CFE.2010404@student.ltu.se>
	 <200708071507.33141.lenb@kernel.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 08 Aug 2007 09:20:07 +0200
Message-Id: <1186557607.8780.85.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 15:07 -0400, Len Brown wrote:
> On Sunday 05 August 2007 16:03, Richard Knutsson wrote:
> > Thomas Renninger wrote:
> > > On Sun, 2007-08-05 at 21:05 +0200, Richard Knutsson wrote:
> > >   
> > >> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> > >> ---
> > >> Got this from the compiler (gcc (GCC) 4.1.2 20070626 (Red Hat 4.1.2-13)):
> > >> drivers/char/sonypi.c:1153: warning: initialization from incompatible pointer type
> > >>
> > >>
> > >> diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
> > >> index 73037a4..2dcd519 100644
> > >> --- a/drivers/char/sonypi.c
> > >> +++ b/drivers/char/sonypi.c
> > >> @@ -1147,10 +1147,15 @@ static int sonypi_acpi_remove(struct acpi_device *device, int type)
> > >>  	return 0;
> > >>  }
> > >>  
> > >> +static const struct acpi_device_id sonypi_acpi_driver_ids[] = {
> > >> +        {ACPI_PROCESSOR_HID, 0},
> > >>     
> > > This is wrong. You need to take the HID the driver should match for, in
> > > this case: {"SNY6001", 0 },
> > >   
> 
> like this?
> 
> http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commitdiff;h=f7b88ccb63188e775fe02e746c39ed177741cfc7;hp=11604ecf6fb9c2ab0152fbddb7ea2724438ef76e
> 
> http://marc.info/?l=linux-acpi&m=118618043526395&w=2

Yes.

Thanks,

    Thomas

