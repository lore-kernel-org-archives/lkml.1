Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYL1X4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYL1X4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYL1X4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:56:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYL1X4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:56:34 -0500
Message-ID: <4958120F.4060804@zytor.com>
Date: Sun, 28 Dec 2008 15:55:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu>
In-Reply-To: <20081228232729.GA2158@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> ok, agreed. I was hoping for some more generic workaround but nothing 
> seemed to keep gcc from inlining such functions.
> 

Other than blacklisting those gcc versions.  It's pretty easy to
understand how a bug like that could creep in, since one of the main
improvements of the early gcc4 series was better inlining as an
optimization.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

