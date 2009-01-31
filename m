Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZAaAxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZAaAxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZAaAw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:52:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZAaAwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:52:55 -0500
Message-ID: <4983A00F.5040505@zytor.com>
Date: Fri, 30 Jan 2009 16:49:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       paulmck@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: Seeing "huh, entered softirq 8 ffffffff802682aa preempt_count
 00000100, exited with 00010100?" in tip.git
References: <498229CF.1090007@goop.org> <20090130005953.GD6716@linux.vnet.ibm.com> <49825B8B.2000202@goop.org> <20090130150859.GB27549@elte.hu> <20090130221747.GA6877@elte.hu> <20090130223455.GA4151@elte.hu> <49839FCB.3010509@goop.org>
In-Reply-To: <49839FCB.3010509@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> I found my bug.  Turns out all my CPUs were sharing the same kernel 
> stack (!), which means it was working surprisingly well, considering...
> 

ROTFLMAO!

	-hpa

