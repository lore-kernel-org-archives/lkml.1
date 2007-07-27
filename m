Return-Path: <linux-kernel-owner+w=401wt.eu-S936346AbXG0QBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936346AbXG0QBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 12:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762766AbXG0QBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 12:01:16 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:4052 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762642AbXG0QBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 12:01:15 -0400
Message-ID: <46AA168B.6000208@roarinelk.homelinux.net>
Date: Fri, 27 Jul 2007 18:00:11 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
User-Agent: Thunderbird/1.0 Mnenhy/0.7
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: Investigating SD card failures
References: <20070727055026.GB27423@roarinelk.homelinux.net> <20070727163035.4ec23c19@poseidon.drzeus.cx>
In-Reply-To: <20070727163035.4ec23c19@poseidon.drzeus.cx>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Thank your for your answer!

Pierre Ossman wrote:
> On Fri, 27 Jul 2007 07:50:26 +0200
> Manuel Lauss <mano@roarinelk.homelinux.net> wrote:
> 
>> Hi Pierre,
>>
>> I have a 1GB SanDisk SD card here which linux does not recognize.
>> Looking at the MMC debug output, I see the MMC core repeatedly
>> issues CMD55/CMD41 commands (which all succeed!) then stops
>> after 100 times.  In sd_ops.c the code checks for a bit to get set.
>> My question is, what exactly is this bit supposed to indicate?
>>
> 
> That the card has initialized. Try extending the time that loop runs and see if the card powers up.

Did that, waited almost 10 seconds, didn't help.  I found a printed
version of the SD spec; it turned out to be a power supply problem.
Apparently the power supply is not strong enough and/or the card
very sensitive to power fluctuations; put in another piece of hardware
with redesigned power supply the card works fine.

Sorry for the noise!

Thanks,
	Manuel Lauss
