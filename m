Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXDQHAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXDQHAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXDQHAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:00:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:7732 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbXDQHAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mB5rfL1JrU73VUcjQZ/0dobOn3KgCxvNSk2nx+xYDymxv6ajpystnUVqS4WWaCHaO8tKP5YU7gouRNqDkHbhc7HvqpX0TppDsOV+0/5g2UfJNnbgyCzuz1glja/aPFSPk+PqkVmM+nkmNheZc5WsPLqLVfaQH/Ch0KPXFHhWn2Y=
Message-ID: <414cba4e0704170000j9ad6156o256ad40e98f7f3ba@mail.gmail.com>
Date: Tue, 17 Apr 2007 09:00:33 +0200
From: emisca <emisca.ml@gmail.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
In-Reply-To: <4623F804.3020405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <461D4E2C.6000704@redhat.com> <20070414105255.GB9157@ucw.cz>
	 <20070415155343.GA12069@khazad-dum.debian.net>
	 <Pine.LNX.4.61.0704152050150.27018@yvahk01.tjqt.qr>
	 <4623F804.3020405@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/17, Chuck Ebbert <cebbert@redhat.com>:
> Jan Engelhardt wrote:
> > On Apr 15 2007 12:53, Henrique de Moraes Holschuh wrote:
> >> On Sat, 14 Apr 2007, Pavel Machek wrote:
> >>> How common are notebooks that cut power to disks during reboot?
> >> Assuming it also does this when running Windows, I'd report it as a grave
> >> bug to the vendor and demand it to be fixed, or the machine to be exchanged
> >> with another model that doesn't have this defect.
> >
> > Given that it does not happen on Windows (IIRC Chuck's post),
> > then just what is Windows [not] doing that Linux does?
>
> It looks like there are two problems here:
>
> (1) Some notebooks power off and back on when restarting.
>     Both Linux and other OS handle that badly because they
>     assume power is not interrupted on reboot. The noise
>     emitted is relatively loud.
>

I'm affected by this problem, hp nx7400 + Seagate Momentus 5400.3 160gb SATA

When "drive spins down, acpi_power_off is written on the console, the
drive spins up again, and 3-4 seconds later the notebook is powered
off, leaving disk heads not parked I think.

I've not tried any new kernel or patches. I'm using stock debian Etch
kernel 2.6.18-5-686.
