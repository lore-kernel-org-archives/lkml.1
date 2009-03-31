Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbZCaRjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbZCaRjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZCaRjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:39:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZCaRjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:39:42 -0400
Message-ID: <49D25554.3020504@vlnb.net>
Date: Tue, 31 Mar 2009 21:39:32 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: scst-devel <scst-devel@lists.sourceforge.net>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [Scst-devel] Linux kernel and block I/O performance
References: <e2e108260903251117n54d0275bk8bf7c9398d9987da@mail.gmail.com>
In-Reply-To: <e2e108260903251117n54d0275bk8bf7c9398d9987da@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+3b4Nol1qnDOtteJwrqjqsXrV2g66XmIjTx4e
 i2LLvXGYqTFNqFC2qKgbGXQVgXNhY4bJKEcz2YwrksF9WDFGhy
 tWANtqK9LAfKiC7En0m4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Bart Van Assche, on 03/25/2009 09:17 PM wrote:
> Hello,
> 
> For anyone who's running SCST performance measurements, please have a
> look at http://lwn.net/Articles/325307/. In this article it is
> explained why 2.6.25 and 2.6.29 perform three times faster on some I/O
> benchmarks than 2.6.26, 2.6.27 and 2.6.28. The relevant kernel commits
> are:
> 
> 2.6.26: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=18ce3751ccd488c78d3827e9f6bf54e6322676fb
> 2.6.29: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=78f707bfc723552e8309b7c38a8d0cc51012e813

Interesting. I've just checked with 2.6.29 on the target. With iSCSI 
still ext3 as a backstorage FS on the target a lot slower on writes than 
xfs (25-100%, deviation between runs is very high). On my system it's 
something like 50-80MB/s vs 100+MB/s. In both cases initiator formatted 
the device in ext3. Test application was famous "dd if=/dev/zero 
of=/mnt/q bs=512K".

Thanks,
Vlad
