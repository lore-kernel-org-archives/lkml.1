Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXJAJLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXJAJLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbXJAJK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:10:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63712 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXJAJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:10:56 -0400
Message-ID: <4700B966.1030508@anagramm.de>
Date: Mon, 01 Oct 2007 11:09:58 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alexander Sabourenkov <screwdriver@lxnt.info>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Promise SATA300 TX4: errors, oops in ext3 code
References: <47009BF6.5000208@lxnt.info>
In-Reply-To: <47009BF6.5000208@lxnt.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18DMTi4sCG/VrjueP62NPrL/8b9ZborxyyE9fw
 fCZeRa9NhK8fH66jSTwixQI42Znq6WWna974sLdzjzmnHpmtkN
 7DX0PM2gNUrJk/UfdLKhQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Sabourenkov schrieb:
 > Hardware:  Athlon64, Asus A8V, Promise SATA300 TX4, 2xSeagate 7200.10
 > 320G, jumper-limited to SATA150.
 > Kernel : 2.6.22.9 amd64
 >
 > Problem:
 > Heavy load causes errors and triggers oops.

Have you checked your memory already (memtest86)?

We have several applications with Promise controllers on strange
hardware and we never had integrity problems with i.e. not so standard
SATA connections over custom vaccum-tight connectors.

 > Problems were blamed:
 >   - SATA300 being too 'hot'  (jumpered the drives)

Is this a common known problem with your harddrives or controller?
(ask google) Otherwise, it sounds like a problem with broken hardware.

 >   - cables (work perfectly on onboard controller)
 >   - interrupt sharing (found the only slot which does not share
 > interrupt line)
 >   - cooling (3 fans installed, smartctl-reported temperature at max load
 > dropped to 35C)

Try to heat up your memory a little (your wife's hair blower).
If it fails more often, your memory is most likely broken.

 >   - weak PSU (installed 600W FSP)
 >   - kernel bugs (upgraded to 2.6.22.9)
 >
 > All those measures significantly dropped error rate (from about 20 to
 > 2-4 per mirror rebuild) but did not eliminate the problem.

Again... sounds like bad memory to me.

Juat my $0.05.
Regards,

Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com


