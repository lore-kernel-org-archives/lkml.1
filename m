Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0BTJiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:38:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:6355 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0BTJiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MW4wKbBF2LaisIJIiza1IVF3cy4T6tfwaFuG+My/OpWQZQUhdd25aZNT7Ypweub3ir
         PzN2rBVbDVgaAu70mCP6WLT7b7l5xiz3CSSlTv3s+MnGTTYxC7m8DMcboIgoAyImDg63
         ILgAZ5SXepV+9Jonuv3hbJQ/NneB4D6Ukgt+U=
MIME-Version: 1.0
In-Reply-To: <4B79BC66.9090408@shikadi.net>
References: <4B78EF9C.6040801@shikadi.net>
	 <20100215090053.GG12076@hack.private> <4B79122A.9070102@shikadi.net>
	 <20100215122732.GM12076@hack.private> <4B79BC66.9090408@shikadi.net>
Date: Sat, 20 Feb 2010 17:38:08 +0800
Message-ID: <2375c9f91002200138u6aee8412q6bc23f1664691be7@mail.gmail.com>
Subject: Re: UML error - apps killed 50% of the time
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 5:28 AM, Adam Nielsen <a.nielsen@shikadi.net> wrote:
>> So what are the errors now? Could you please provide your boot log?
>
> Just more random tasks being killed:
>
>  * Calculating module dependencies .../sbin/modules-update: line 73:   967
> Broken pipe             sed -ne 1p "${x}"
>       968 Killed                  | egrep -q "^${HEADER}"
>  * Mounting local filesystems ... [ ok ]
> /etc/init.d/localmount: line 9:   982 Killed                  modprobe
> usbcore >&/dev/null
>  * Cleaning /tmp directory ... [ ok ]
> /sbin/depscan.sh: line 21:  1055 Killed                  mkdir -p -m 0755
> "${svcdir}/${x}" 2>/dev/null
>  *  Could not create needed directory '/var/lib/init.d/snapshot'!
> INIT: Entering runlevel: 3
> /lib/rcscripts/sh/rc-services.sh: line 35:  1096 Killed /sbin/depscan.sh -u
>
>  * Error running '/sbin/depscan.sh'!
>  * Please correct any problems above.
> /sbin/functions.sh: line 184:  1098 Killed                  /usr/bin/logger
> -p "${pri}" -t "${tag}" -- "$*"
>

Oh, probably caused by the same commit....

I will check it tonight.

Thank you.
