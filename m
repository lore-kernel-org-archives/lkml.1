Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYL1XMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYL1XMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYL1XME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:12:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbYL1XMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:12:03 -0500
Date: Sun, 28 Dec 2008 15:11:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
In-Reply-To: <20081227173839.GA9793@elte.hu>
Message-ID: <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 27 Dec 2008, Ingo Molnar wrote:
> 
> well, it's a regression that is being worked on: certain buggy GCC 
> versions (unclear yet what scope but quite rare it appears) optimize out 
> __weak function calls incorrectly.

We've hit that kind of bug before, haven't we? I think the solution last 
time was to make sure that the __weak function is never in the same 
compilation unit as a call to it.

			Linus
