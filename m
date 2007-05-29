Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbXE2Mye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbXE2Mye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXE2Mxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:53:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:37685 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXE2Mxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ZGuNY8NmckQiE/H0Fh3D4JS+49p8bcn8UBudVeu6fLflV0AO8Rfp1aXDAKNIWUuxi/Qivd5dhntT2KyWnqTdz1QiRbE1cCroKorfAdmVXjMG4xD08Uzw1oB33//AVuJMF5ihq8VTuMkv9aUEiEuZw/DaVgX8ajhhujz3p3PRP04=
Message-ID: <465C2253.4070307@googlemail.com>
Date: Tue, 29 May 2007 14:53:39 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Ben Collins <bcollins@ubuntu.com>, yoshfuji@linux-ipv6.org,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org, developers@islsm.org,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       linux-ide@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Francis Russell <francisrussell@btopenworld.com>,
       Alan Cox <alan@redhat.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
Subject: Re: [2/3] 2.6.22-rc3: known regressions with patches
References: <465C203A.1020200@googlemail.com>
In-Reply-To: <465C203A.1020200@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Networking

Subject    : Oops with prism54 in 2.6.22-rc3
References : http://lkml.org/lkml/2007/5/26/54
Submitter  : Maximilian Engelhardt <maxi@daemonizer.de>
Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de> 
Patch      : http://lkml.org/lkml/2007/5/27/182
Status     : patch available


Subject    : OOPS triggered by ip(8) deconfiguring a network interface
References : http://bugzilla.kernel.org/show_bug.cgi?id=8491
Submitter  : Ben Collins <bcollins@ubuntu.com>
Patch      : http://marc.info/?l=linux-netdev&m=117915849224816&w=2
             commit 5632c5152aa621885d87ea0b8fdd5a6bb9f69c6f
Status     : bug probably fixed

SATA/PATA

Subject    : pata_via appears to incorrectly detects 40-pin cable
References : http://lkml.org/lkml/2007/5/17/273
Submitter  : Francis Russell <francisrussell@btopenworld.com>
Status     : Not really a regression. Alan seems to have a general fix.
             (Tejun Heo)

Subject    : libata reset-seq merge broke sata_sil on sh
References : http://lkml.org/lkml/2007/5/10/63
Submitter  : Paul Mundt <lethal@linux-sh.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Caused-By  : commit 4750def52cb2c21732dda9aa1d43a07db37b0186
Patch      : http://lkml.org/lkml/2007/5/19/161
Status     : patch available



Sparc64

Subject    : arch/sparc64/time.c doesn't compile on Ultra 1 (no PCI)
References : http://bugzilla.kernel.org/show_bug.cgi?id=8540
Submitter  : Horst H. von Brand <vonbrand@inf.utfsm.cl>
Status     : patch available



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"



