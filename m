Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbXJYUjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbXJYUjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbXJYUjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:39:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:56788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536AbXJYUjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:39:03 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.6 patch] acpi/battery.c: remove dead code
Date: Thu, 25 Oct 2007 16:38:41 -0400
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071024162537.GA30533@stusta.de> <471F7E7D.1080501@gmail.com>
In-Reply-To: <471F7E7D.1080501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251638.41567.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-len

On Wednesday 24 October 2007 13:18, Alexey Starikovskiy wrote:
> Adrian Bunk wrote:
> > After commit f1d4661abe05d0a2c014166042d15ed8b69ae8f2 this was dead 
> > code.
> > 
> > Spotted by the Coverity checker.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked. Thanks.
> > 
> > ---
> > --- linux-2.6/drivers/acpi/battery.c.old	2007-10-23 18:44:13.000000000 +0200
> > +++ linux-2.6/drivers/acpi/battery.c	2007-10-23 18:44:43.000000000 +0200
> > @@ -550,18 +550,14 @@ static ssize_t acpi_battery_write_alarm(
> >  	int result = 0;
> >  	char alarm_string[12] = { '\0' };
> >  	struct seq_file *m = file->private_data;
> >  	struct acpi_battery *battery = m->private;
> >  
> >  	if (!battery || (count > sizeof(alarm_string) - 1))
> >  		return -EINVAL;
> > -	if (result) {
> > -		result = -ENODEV;
> > -		goto end;
> > -	}
> >  	if (!acpi_battery_present(battery)) {
> >  		result = -ENODEV;
> >  		goto end;
> >  	}
> >  	if (copy_from_user(alarm_string, buffer, count)) {
> >  		result = -EFAULT;
> >  		goto end;
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
