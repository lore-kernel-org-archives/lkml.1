Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbXEZNxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbXEZNxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 09:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXEZNxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 09:53:13 -0400
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:52385 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbXEZNxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 09:53:12 -0400
Date: Sat, 26 May 2007 15:52:23 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Tommy Vercetti <vercetti@zlew.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Message-ID: <20070526155223.1bedba5a@localhost>
In-Reply-To: <200705261505.38109@gj-laptop>
References: <200705261505.38109@gj-laptop>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007 15:05:38 +0200
Tommy Vercetti <vercetti@zlew.org> wrote:

> I was trying to get answer to my question around, but no one knows.
> I do have DMA turned on, etc, yet - on extensive harddrive operations wait 
> time is 90+% , which means that machine is waiting, rather than doing 
> something meanwhile. (I guess). 
> Can someone describe to me , in more detail why is that happening, and what 
> steps should I consider to avoid it ? I couldn't find any answers that would 
> have help me on net.

It means that the disk is slow and the CPU is fast... so while the disk
is busy seeking and reading data the CPU has nothing to do but wait for
it.

Idle == CPU has nothing to do
Waiting == CPU has nothing to do, but it will have as soon as the slow
	disk (or whatever) delivers data


Anyway 97% is quite high... what CPU / Hard Disk do you have?

What kernel version?
I/O scheduler? (cat /sys/block/DEVICE/queue/scheduler)
Filesystem?

And what time of "operations" are you doing?

-- 
	Paolo Ornati
	Linux 2.6.22-rc3-cfs-v14-gf193016a on x86_64
