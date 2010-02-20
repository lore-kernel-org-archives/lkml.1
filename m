Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0BTOmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:42:49 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:47472 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab0BTOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pS48DWlekP4X9IPflKJJXsWGUJhW6MAmDR52k/BrT1MBCO9Lpp6yfdohemEdwBMuWw
         ZPvz1oDX0X4n133H/8AlXCzsxTnC1dZdN9CraEMheqhsjlL+Jj0fBB2E8/G4lYShHP/V
         vDYjtK6FLvjK+ZGJTx4RBtklI58zvd8KiXjq8=
Date: Sat, 20 Feb 2010 22:45:29 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML error - apps killed 50% of the time
Message-ID: <20100220144529.GE3000@hack>
References: <4B78EF9C.6040801@shikadi.net> <20100215090053.GG12076@hack.private> <4B79122A.9070102@shikadi.net> <20100215122732.GM12076@hack.private> <4B79BC66.9090408@shikadi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B79BC66.9090408@shikadi.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 07:28:06AM +1000, Adam Nielsen wrote:
>> So what are the errors now? Could you please provide your boot log?
>
> Just more random tasks being killed:
>
>  * Calculating module dependencies .../sbin/modules-update: line 73:   
> 967 Broken pipe             sed -ne 1p "${x}"
>        968 Killed                  | egrep -q "^${HEADER}"
>  * Mounting local filesystems ... [ ok ]
> /etc/init.d/localmount: line 9:   982 Killed                  modprobe 
> usbcore >&/dev/null
>  * Cleaning /tmp directory ... [ ok ]
> /sbin/depscan.sh: line 21:  1055 Killed                  mkdir -p -m 0755 
> "${svcdir}/${x}" 2>/dev/null
>  *  Could not create needed directory '/var/lib/init.d/snapshot'!
> INIT: Entering runlevel: 3
> /lib/rcscripts/sh/rc-services.sh: line 35:  1096 Killed /sbin/depscan.sh 
> -u
>
>  * Error running '/sbin/depscan.sh'!
>  * Please correct any problems above.
> /sbin/functions.sh: line 184:  1098 Killed                  
> /usr/bin/logger -p "${pri}" -t "${tag}" -- "$*"
>

I tested it, it is fixed by the updated patch:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-02/msg05620.html
