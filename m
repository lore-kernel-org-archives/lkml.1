Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXDVSrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXDVSrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbXDVSrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:47:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:60176 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbXDVSrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HnGrfO31vK2hd2gEAHM7ta0Kn7Z+ghVqf98jfQnzEPSyopF/69ukW5/xrv88Hv4LRofD7Vgu3QxmqHk7S9IimTFvrib9BlQYIFqQq7/9r4wkl90StX6CNI/GcMWlJLMMsZbfsu67upzvh0djRnzmUjpaPP2B9y+rkSMVXUhrmHk=
Message-ID: <3efb10970704221147u4bfed2a5r358a10e279936556@mail.gmail.com>
Date: Sun, 22 Apr 2007 20:47:05 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: gtod/clocksource/clockevents documentation
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200704221113.21778.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <3efb10970704211414q7c66c154m79cc06db61eb76be@mail.gmail.com>
	 <200704211600.02278.david-b@pacbell.net>
	 <3efb10970704220900m53874769ta8f540098ea7d9de@mail.gmail.com>
	 <200704221113.21778.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

> > But, unfortunately, I have some problems with compiling the kernel, as
> > this patch does not enable CONFIG_GENERIC_TIME, while the patch you
> > published earlier did.
>
> I'm not sure which patch you mean.  I tested only in conjunction with
> updates specific to the at91rm9200.

To be clear, I also meant the patches for the at91rm9200, where you
had added 'select GENERIC_TIME', I copied that to my at91sam9261
work-in-progress-patch...
I thought adding a clocksource was enough, but I am starting to doubt
about that now...
So, I dive into it some deeper tomorrow morning.
I believe I also have to implement a clockevents implementation
also... (for GENERIC_CLOCKEVENTS)

Thanks for your help!

(If I have something working, I will publish it, maybe you can use it
also for your work/patch?)


Kind Regards,

Remy Böhmer
