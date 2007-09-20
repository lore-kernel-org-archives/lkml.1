Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbXITMCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbXITMCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXITMCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:02:34 -0400
Received: from sslsrv.de ([62.75.159.123]:40173 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXITMCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:02:33 -0400
Message-ID: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
In-Reply-To: <E1IYJyC-0000iq-TR@be1.lrz>
References: <952DN-83o-31@gated-at.bofh.it> <954cl-29C-3@gated-at.bofh.it>
    <95ctn-74b-15@gated-at.bofh.it> <95cMH-7um-19@gated-at.bofh.it>
    <95gdA-4OZ-7@gated-at.bofh.it> <E1IYJyC-0000iq-TR@be1.lrz>
Date: Thu, 20 Sep 2007 13:59:19 +0200 (CEST)
Subject: Re: sys_chroot+sys_fchdir Fix
From: "Philipp Marek" <philipp@marek.priv.at>
To: 7eggert@gmx.de
Cc: "David Newall" <david@davidnewall.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Bill Davidsen" <davidsen@tmr.com>, "majkls" <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-4.fc1.1.legacy
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please, everybody,

don't change that.

I'm currently using that *feature* (yes, I see it as that) in my
fsvs-chrooter-utility (see
http://fsvs.tigris.org/source/browse/*checkout*/fsvs/trunk/www/doxygen/html/group__howto__chroot.html)
for easier usage of fsvs on older systems.

- User starts a small wrapper,
- that opens "/",
- chroot()s into a directory and starts fsvs.
- fsvs gets its libraries loaded
- and chroot()s back to the original system.

Voila! fsvs can use the newest available libraries for that architecture,
without having to change the installed system.


Please, keep that feature - as already mentioned, UID 0 is required
anyway, and such processes can get out of (nearly) anything.


Regards,

Phil


-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
