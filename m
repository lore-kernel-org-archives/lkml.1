Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0BOV2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:28:11 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:46040 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab0BOV2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:28:09 -0500
Message-ID: <4B79BC66.9090408@shikadi.net>
Date: Tue, 16 Feb 2010 07:28:06 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML error - apps killed 50% of the time
References: <4B78EF9C.6040801@shikadi.net> <20100215090053.GG12076@hack.private> <4B79122A.9070102@shikadi.net> <20100215122732.GM12076@hack.private>
In-Reply-To: <20100215122732.GM12076@hack.private>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So what are the errors now? Could you please provide your boot log?

Just more random tasks being killed:

  * Calculating module dependencies .../sbin/modules-update: line 73:   967 
Broken pipe             sed -ne 1p "${x}"
        968 Killed                  | egrep -q "^${HEADER}"
  * Mounting local filesystems ... [ ok ]
/etc/init.d/localmount: line 9:   982 Killed                  modprobe usbcore 
 >&/dev/null
  * Cleaning /tmp directory ... [ ok ]
/sbin/depscan.sh: line 21:  1055 Killed                  mkdir -p -m 0755 
"${svcdir}/${x}" 2>/dev/null
  *  Could not create needed directory '/var/lib/init.d/snapshot'!
INIT: Entering runlevel: 3
/lib/rcscripts/sh/rc-services.sh: line 35:  1096 Killed 
/sbin/depscan.sh -u

  * Error running '/sbin/depscan.sh'!
  * Please correct any problems above.
/sbin/functions.sh: line 184:  1098 Killed                  /usr/bin/logger -p 
"${pri}" -t "${tag}" -- "$*"

Cheers,
Adam.
