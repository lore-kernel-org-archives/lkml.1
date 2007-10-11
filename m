Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXJKGIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXJKGIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXJKGIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:08:34 -0400
Received: from hall.aurel32.net ([88.191.38.19]:55605 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbXJKGIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:08:32 -0400
Message-ID: <470DBDC7.8000304@aurel32.net>
Date: Thu, 11 Oct 2007 08:08:07 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
User-Agent: IceDove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
References: <1192053794.15601.47.camel@gaivota>	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>	 <alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org> <d9def9db0710102150l3aa0626es90184c24875bc2e9@mail.gmail.com>
In-Reply-To: <d9def9db0710102150l3aa0626es90184c24875bc2e9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger a écrit :
> On 10/11/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> As such, the old and decrepit em28xx driver seems more useful to people,
>> since at least it supports the limited set of hardware on its own.
> 
> it does not since it's broken and feature limited. On the other side

I have a device which works perfectly with it if you add the vendor and
product ID to the list. I don't really call that broken. And it doesn't
need a firmware.

Please think that a lot of persons do not have enough knowledge to
compile out of tree drivers, and that a lot more do not even know about
this out of tree driver.

> it requires a firmware from userspace too so I don't think it matters
> at all if the algorithm is done in kernelspace or userspace since it
> depends on such a blob (and I cannot get the source for that firmware,
> if someone's interested in that he has to disassemble the firmware).
> 

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
