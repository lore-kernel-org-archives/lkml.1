Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYCSWOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYCSWOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761512AbYCSUmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:42:15 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:55092 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbYCSUmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:42:12 -0400
Message-ID: <47E08762.9090704@gmail.com>
Date: Wed, 19 Mar 2008 12:24:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jan Kasprzak <kas@fi.muni.cz>
CC: =?UTF-8?B?TWFsdGUgU2NocsO2ZGVy?= <maltesch@gmx.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot (resend)
References: <20080214184700.0bd3837d@highlander.home.lan> <47B4D02E.9030101@gmail.com> <20080215191215.430ee2e0@highlander.home.lan> <47BCE71F.2000309@gmail.com> <20080221172757.44882428@highlander.home.lan> <20080317210045.GG3189@fi.muni.cz> <20080318140116.GC8480@fi.muni.cz>
In-Reply-To: <20080318140116.GC8480@fi.muni.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kasprzak wrote:
> Jan Kasprzak wrote:
> : Malte Schröder wrote:
> : : I "solved" the problem by updating the BIOS. It now works perfectly. I
> : : thought I had mailed that .. maybe I forgot.
> : 
> : 	I have the same problem (ASUS M2R32-MVP board with SB600 chipset,
> : Athlon64 X2), but I am already using the latest BIOS for this mainboard.
> 
> 	Sorry for the noise, there is even newer BIOS (dated Mar 01),
> and with this BIOS my mainboard works in AHCI mode even with 2.6.25-rc6.

Hmm... I still wanna know why it got broke in the first place.  The only
thing I can think of is IRQ routing problem in which case pci=nomsi or
irqpoll should help.  Any chance you can test the old BIOS?

-- 
tejun
