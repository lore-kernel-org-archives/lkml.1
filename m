Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXDBPki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXDBPki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbXDBPkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:40:37 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:60180 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbXDBPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:40:37 -0400
Message-ID: <4611239D.3070008@gmail.com>
Date: Mon, 02 Apr 2007 17:39:09 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com> <46104954.50608@gmail.com> <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI> <20070402071018.GE11996@kernel.dk>
In-Reply-To: <20070402071018.GE11996@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2007 09:10 AM, Jens Axboe wrote:

> Updated patch attached :-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 0bc8b0b..cff761a 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -324,3 +324,10 @@ Why:	the i8xx_tco watchdog driver has been replaced by the iTCO_wdt
>  Who:	Wim Van Sebroeck <wim@iguana.be>
>  
>  ---------------------------
> +
> +What:	The legacy CDROM drivers (drivers/cdrom/, except cdrom.c)
> +When:	In 2.6.23

Not going to complain about it loudly. I like playing with these old 
drives, but the drivers are so immensely broken that they don't seem to 
serve a very useful purpose anymore; even if I, or someone else, would 
ever get around to try and revive this hardware under Linux; the current 
state of these drivers seems to imply we'd be better of starting from 
scratch.

And even more so since I expect that any new attempts should do the "no 
really, I'm a scsi drive" thing that most anything else is doing these 
days. Using a different infrastructure like that would, I presume, mean 
that really only the hardware details would remain useful from the old 
drivers, and those will be present inside linux-2.6.22.tar.gz same as 
before.

Having said that, it would still be good to have mcdx functional so 
please don't let me keep you, Pekka, or anyone else from looking :-)

With a bit of luck sbpcd and cdu31a (and cm206 as the other controller 
that I have) will be similarly broken and having an example in mcdx will 
be useful whatever happens to the drivers in the upstream tree...

> +Why:	They are all terminally broken (most don't even compile)

That's not true though... I just checked and they all compile on 
2.6.20.4. sbpcd and cm206 with cli/sti warnings, the others without even.

Rene.
