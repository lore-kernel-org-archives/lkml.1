Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYGZKeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYGZKeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 06:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYGZKeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 06:34:01 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3352 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYGZKeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 06:34:00 -0400
Message-ID: <488AFD90.9040204@xs4all.nl>
Date: Sat, 26 Jul 2008 12:33:52 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: What to do with `kswapd0: page allocation failure. ` ?
References: <20080726060755.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com> <488AAB54.8070801@xs4all.nl> <20080726184636.3175.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080726184636.3175.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>> no bug.
>>> this stack trace speak to
>>>
>>> 1. memory pressure increased
>>> 2. kswapd ran
>>> 3. network packet received
>>> 4. interrupt for network happend
>>> 5. but can't allocate memory for network buffer(skb).
>>> 6. Then, packet dropped
>>> 7. Then, warning happend.
>>>
>>> your network peer may resend the same packet after few times.
>>> no problem.
>> Thanks.
>> This was on a 4GB AMD X86_64 machine running Fedora 9.
>> The memory was not loaded that much. (~2 GB)
>> Or was the (largish) file being cached, filling up RAM?
> 
> maybe..

I can reproduce this by wget'ing a 5.xGB file from my MythTV box.
The receiving end is a Fedora 9, AMD x86_64 box with an Abit m56s-s3
board using nVidia Corporation MCP65 Ethernet (rev a3).
It uses the forcedeth: Reverse Engineered nForce ethernet driver.
Version 0.61.

Should I forward this info to someone so this could be fixed?
Someone doing the kernel memory management?
Or forcedeth?
Or?

Please let me know.

Thanks,
Udo


