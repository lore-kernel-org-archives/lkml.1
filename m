Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0BAS6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:58:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829Ab0BAS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:58:04 -0500
Date: Mon, 1 Feb 2010 10:56:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       Dave Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       John Kacur <jkacur@gmail.com>
Subject: Re: Radeon KMS regression still present in 2.6.33-rc6
In-Reply-To: <1264897781.1528.7.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002011056030.4206@localhost.localdomain>
References: <1264871899.1533.6.camel@localhost.localdomain>  <alpine.LFD.2.00.1001300929260.4206@localhost.localdomain>  <201001302050.11897.johannes.hirte@fem.tu-ilmenau.de>  <alpine.LFD.2.00.1001301153390.4206@localhost.localdomain>
 <1264897781.1528.7.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Jan 2010, Kevin Winchester wrote:
> 
> Thank you - the patch from FUJITA Tomonori corrected the issue.
> 
> I also tried out the additional patches from John Kacur.  They did not
> break anything that I could see, and the logic behind them seems
> reasonable to me.  They weren't necessary to fix my problem though, so I
> guess they are likely not 2.6.33 material (unless they are critical for
> someone else).

All right. Fix merged (commit 61684ceaad) and pushed out.

		Linus
