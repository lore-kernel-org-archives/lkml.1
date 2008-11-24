Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYKXQMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYKXQMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYKXQLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:11:55 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55745 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbYKXQLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:11:54 -0500
Message-ID: <492AD249.3020309@lwfinger.net>
Date: Mon, 24 Nov 2008 10:11:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Yuval Hager <yuval@avramzon.net>
CC: Michael Buesch <mb@bu3sch.de>, LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
Subject: Re: BCM4312 Fails when xdm is started
References: <200811151801.02369.yuval@avramzon.net> <4929C68E.6080401@lwfinger.net> <200811241049.45734.yuval@avramzon.net> <200811241155.47079.mb@bu3sch.de>
In-Reply-To: <200811241155.47079.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Monday 24 November 2008 09:49:38 Yuval Hager wrote:
>> * Now check this out - the output of lspci -d 14e4:4312 -x
>> 02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev ff)
>> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>
>> (I double checked this)
>>
>> huh?
> 
> Hah, interesting. I think your hardware may be faulty, in fact.
> To me it really seems like the mainboard has power failures on the PCI bus.
> 
> This is a laptop, so you can't pull random hardware? Can you run some
> hardware burn-in tests like mprime (http://mersenne.org/freesoft/) or memtest?
> If that doesn't help, can you try with another operating system?
> 

I also think you are seeing a hardware failure. Another test to try is
http://freshmeat.net/projects/cpuburn/?topic_id=146, which will exercise the system.

Larry
