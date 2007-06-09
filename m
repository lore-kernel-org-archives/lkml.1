Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbXFIRlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbXFIRlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbXFIRkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:40:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:5598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbXFIRko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=p6y8QJsKS2OqhzswAlphrxvE1TzUqUcfbUGeBn7/HZ9k+rkujsFP+3TglnuAvAz+Ke3udA2fPPcRorGu8ueYHiOHcjAgwX9R3xkA1t5+xNZ/37HdZa7A5KDMjGxQh6m4i+xXjepdZKRXZ9w70afszoqqDu/NVtq9ixbcCNrNUVU=
Message-ID: <466AE609.1030605@googlemail.com>
Date: Sat, 09 Jun 2007 19:40:25 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, Robert de Rooy <robert.de.rooy@gmail.com>,
       Gregor Jasny <gjasny@googlemail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mark Lord <mlord@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@redhat.com>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [2/3] 2.6.22-rc4: known regressions v2
References: <466ADBE4.5090707@googlemail.com>
In-Reply-To: <466ADBE4.5090707@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Handled-By : Takashi Iwai <tiwai@suse.de>
Status     : Unknown



IDE

Subject    : libata and legacy ide pcmcia failure
References : http://lkml.org/lkml/2007/5/17/305
Submitter  : Robert de Rooy <robert.de.rooy@gmail.com>
Handled-By : Mark Lord <mlord@pobox.com>
Status     : problem is being debugged



SATA/PATA

Subject    : 22-rc3 broke the CDROM in Dell notebook
References : http://lkml.org/lkml/2007/5/27/63
Submitter  : Gregor Jasny <gjasny@googlemail.com>
Handled-By : Tejun Heo <htejun@gmail.com>
             Jeff Garzik <jeff@garzik.org>
Caused-By  : Tejun Heo <htejun@gmail.com>
             commit d4b2bab4f26345ea1803feb23ea92fbe3f6b77bc
Status     : problem is being debugged



Sparc64

Subject    : 2.6.22-rc broke X on Ultra5
References : http://lkml.org/lkml/2007/5/22/78
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Handled-By : David Miller <davem@davemloft.net>
Status     : problem is being debugged



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
