Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYJKBnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYJKBnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 21:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYJKBnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 21:43:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYJKBnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 21:43:37 -0400
Message-ID: <48F00476.6030108@zytor.com>
Date: Fri, 10 Oct 2008 18:42:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [bug] latest -git boot hang
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org>
In-Reply-To: <48EFF84B.5060108@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 
> Yeap, if fedora didn't work, I think it should be hidden.  Do we already
> have place to hide things like this?
> 

By the way, I don't see anything in this patchset that lets userspace 
discover the parent device.  Since the old rule of

	partition device = parent device + partition number

... no longer holds, this is a serious omission for something that is in 
mainstream (and therefore *requires* that a new interface is deployed 
for anything that cares.)

This will have to be addressed before 2.6.28 final.

	-hpa
