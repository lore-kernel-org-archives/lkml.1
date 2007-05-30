Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbXE3J3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbXE3J3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXE3J2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:28:52 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:44414 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXE3J2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:28:51 -0400
Message-ID: <465D43C0.60609@dunaweb.hu>
Date: Wed, 30 May 2007 11:28:32 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Look at how slow the raid benchmarks are in dmesg with 8GB of memory!
>
> [   59.592560] raid6: using algorithm sse2x4 (476 MB/s)
> [   59.597558] raid5: using function: generic_sse (56.000 MB/sec)
>
> Yikes!
>
> With mem=4096M:
> [   60.336352] raid6: using algorithm sse2x4 (6804 MB/s)
> [   60.341345] raid5: using function: generic_sse (8552.000 MB/sec)
>
> What is going on here?
>
> Justin.

I saw a similar effect on a P5 board that could
only cache 64MB of memory a long time ago.
Putting more memory into it made the machine slower
and e.g. made the sym2 driver giving up at initialization.
Maybe it's a modern reincarnation of the problem?

Best regards,
Zoltán Böszörményi

