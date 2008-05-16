Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYEPKVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYEPKVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYEPKVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:21:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45350 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbYEPKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:21:45 -0400
Message-ID: <482D6037.7070606@firstfloor.org>
Date: Fri, 16 May 2008 12:21:43 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
References: <20080514174955.GA515@elte.hu>	<87fxsk7n7e.fsf@basil.nowhere.org>	<20080514220034.51eae9e0@core>	<482B5614.3060203@firstfloor.org>	<20080514221957.6edb2d60@core>	<alpine.LFD.1.10.0805141435540.3019@woody.linux-foundation.org>	<482B61C2.9070106@firstfloor.org>	<20080515143430.6a94508d@core>	<20080515142729.GA30216@one.firstfloor.org> <20080515163659.61f5df0f@core>
In-Reply-To: <20080515163659.61f5df0f@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> file structures - as well
>> How so?
> 
> Take a look at how file->f_flags is locked.

Ah I posted patches to fix that one a couple of weeks
ago, but unfortunately they fell out of -mm again.

It was part of the "unlocked fasync" patchkit.

-Andi

