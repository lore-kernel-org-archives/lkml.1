Return-Path: <linux-kernel-owner+w=401wt.eu-S934290AbXHGTIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290AbXHGTIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXHGTHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:07:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:37127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbXHGTHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:07:49 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] sonypi: Fix initialization warning
Date: Tue, 7 Aug 2007 15:07:32 -0400
User-Agent: KMail/1.9.5
Cc: trenn@suse.de, Ben Collins <bcollins@ubuntu.com>,
       linux-acpi@vger.kernel.org, Stelian Pop <stelian@popies.net>,
       linux-kernel@vger.kernel.org
References: <46B61F70.90005@student.ltu.se> <1186343443.3858.46.camel@fanta4.site> <46B62CFE.2010404@student.ltu.se>
In-Reply-To: <46B62CFE.2010404@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708071507.33141.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 August 2007 16:03, Richard Knutsson wrote:
> Thomas Renninger wrote:
> > On Sun, 2007-08-05 at 21:05 +0200, Richard Knutsson wrote:
> >   
> >> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> >> ---
> >> Got this from the compiler (gcc (GCC) 4.1.2 20070626 (Red Hat 4.1.2-13)):
> >> drivers/char/sonypi.c:1153: warning: initialization from incompatible pointer type
> >>
> >>
> >> diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
> >> index 73037a4..2dcd519 100644
> >> --- a/drivers/char/sonypi.c
> >> +++ b/drivers/char/sonypi.c
> >> @@ -1147,10 +1147,15 @@ static int sonypi_acpi_remove(struct acpi_device *device, int type)
> >>  	return 0;
> >>  }
> >>  
> >> +static const struct acpi_device_id sonypi_acpi_driver_ids[] = {
> >> +        {ACPI_PROCESSOR_HID, 0},
> >>     
> > This is wrong. You need to take the HID the driver should match for, in
> > this case: {"SNY6001", 0 },
> >   

like this?

http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commitdiff;h=f7b88ccb63188e775fe02e746c39ed177741cfc7;hp=11604ecf6fb9c2ab0152fbddb7ea2724438ef76e

http://marc.info/?l=linux-acpi&m=118618043526395&w=2
