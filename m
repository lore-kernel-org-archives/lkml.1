Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbYHFGBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbYHFGBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYHFGBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:01:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbYHFGBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:01:22 -0400
Date: Tue, 5 Aug 2008 23:01:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
In-Reply-To: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808052259070.15995@nehalem.linux-foundation.org>
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Aug 2008, Jeff Chua wrote:
> 
> How can I debug this further? I'm using the latest linux git pull.

One trivial thing to try would be to just bisect it. I assume 2.6.26 is 
fine, so while it will take a few boots to try it out (there's 8111 
commits in between, so 13 reboots should do it), the advantage of 
bisection is that it's fairly straightforward to do even if you don't have 
any clue where the problem might lurk.

And with your machine, recompiling the kernel 13 times shouldn't take that 
long ;)

		Linus
