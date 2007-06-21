Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbXFUQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbXFUQfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbXFUQfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:35:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:41733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbXFUQf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=d7JF9UYYr+3VzR7puPOLmqwle/c6Oz2I2ZZldXgdVVLSX6ZZ75A/OLpUr/W8Qg4wRZcDhViULid27FACQ8C+U07NhWjQ3yjahPWfMHnsm9IRzd+S/gcsUflm6dwDUnxhPWOwqSnXJLpcWOgkfykvxiGZiNwT5zlorwmHOXlyjv0=
Message-ID: <467AA8AB.2010107@googlemail.com>
Date: Thu, 21 Jun 2007 18:34:51 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Rodrigo Luiz <troops.of.doom@gmail.com>,
       CHIKAMA Masaki <masaki-c@nict.go.jp>,
       Christian Volkmann <haveaniceday@cv-sv.de>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [1/2] 2.6.22-rc5: known regressions v2
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc5.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

(BTW. There is a new category called "Will be fixed in 2.6.23")



Unclassified

Subject    : PANIC: CPU too old for this kernel. with Crusoe CPU
References : http://bugzilla.kernel.org/show_bug.cgi?id=8647
Submitter  : CHIKAMA Masaki <masaki-c@nict.go.jp>
Caused-By  : Andi Kleen <ak@suse.de>
             or Christian Volkmann <haveaniceday@cv-sv.de>
             one of those commits:
             commit 4c1f59d8be7e5da75d9380da23671005b363c45c
             commit 39427d6e595ebee38fdd77bcf55d6b13d7a4324a
             commit fd0581bbb40d8f4b0e4b3a4de2258a50df37bb57
             commit c7f81c9453375d6416658995eafd3397cb9bba1d
             commit 3671df8572a299acff9c9cac2bf7279ee614d154
Status     : unknown

Subject    : Kernel hang on CMOS_READ
References : http://lkml.org/lkml/2007/6/3/138
Submitter  : Rodrigo Luiz <troops.of.doom@gmail.com>
Status     : Unknown



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Handled-By : Takashi Iwai <tiwai@suse.de>
Status     : Unknown



FS

Subject    : 2.6.22-rc4-git5 reiserfs: null ptr deref.
References : http://lkml.org/lkml/2007/6/13/322
Submitter  : Randy Dunlap <randy.dunlap@oracle.com>
Handled-By : Vladimir V. Saveliev <vs@namesys.com>
Status     : problem is being debugged



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
