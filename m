Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbYL2AjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbYL2AjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL2Ai6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:38:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYL2Ai6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:38:58 -0500
Message-ID: <49581C04.5040207@zytor.com>
Date: Sun, 28 Dec 2008 16:38:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>	 <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>	 <20081227173839.GA9793@elte.hu>	 <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>	 <20081228232729.GA2158@elte.hu> <4958120F.4060804@zytor.com> <86802c440812281606o6e8fbde1ub2e5055f83fea47@mail.gmail.com>
In-Reply-To: <86802c440812281606o6e8fbde1ub2e5055f83fea47@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> 1. one time path add one dummy printk
> 2. multi path, could move it to another file.
> could add one like kernel/weak.c to collect those ...
> 

I had a silly thought about scanning the source code for some kind of
magic declarator that would then be collected into a master weak symbol
dummy function kind of file.  It really seems more trouble than it's
worth; we don't have *that* many weaks in the kernel, not all of them
are trivial, and that way it's better to keep them as close as we can to
the point of usage.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

