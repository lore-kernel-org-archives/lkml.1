Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXJBJZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXJBJZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXJBJZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:25:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXJBJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:25:03 -0400
Message-ID: <47020E6D.6070902@anagramm.de>
Date: Tue, 02 Oct 2007 11:25:01 +0200
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
X-Provags-ID: V01U2FsdGVkX1+k7P1FR7qTXPw4NTqAaiMpEqTVHsd/ayqL8a+
 XJfl2NhxcIzUKeGQj4Y0+MXawEkzfyp+WqRjpOmaV2ri9VNeef
 /C2NpaVTujj9baRNWlCNA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Sabourenkov schrieb:
 > Hardware:  Athlon64, Asus A8V, Promise SATA300 TX4, 2xSeagate 7200.10
 > 320G, jumper-limited to SATA150.
 > Kernel : 2.6.22.9 amd64
 >
 > Problem:
 > Heavy load causes errors and triggers oops.
 >
 > History:
 > Problems were first encountered on kernel 2.6.19, both i686 ("old"
 > system) and amd64 (gentoo installation CD).
 > Can't say anything about older kernels. Most probably they have same
 > issues (or worse).
 >
 > Problems were blamed:
 >   - SATA300 being too 'hot'  (jumpered the drives)

Did you turn it back to SATA300 and does it basically still work?
Then cool it actively and see if the error rate depends on it.

In one of my Promise HDD (PDC20275) controller designs I forgot to connect
the thermal pad (they call it E-PAD) properly to a GND plane so it just
worked with lots of errors which were also temperature sensitive (so, a
typical hardware design flaw :-).
On a PCI add-on card with the same chip, the E-PAD also didn't look
soldered over it's whole E-PAD area but it was working.

As you might have noticed, I am more into hardware debugging.
Propably some kernel gurus might have other ideas (related to software).

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


