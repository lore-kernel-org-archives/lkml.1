Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbZEKSPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbZEKSPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZEKSPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:15:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756807AbZEKSPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:15:04 -0400
Date: Mon, 11 May 2009 11:10:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Parag Warudkar <parag.lkml@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
cc: LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
In-Reply-To: <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905111105170.3586@localhost.localdomain>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>  <1241165805.13562.2.camel@johannes.local> <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com> <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 May 2009, Linus Torvalds wrote:
>
> .. and I _can_ verify this problem myself.

I take that back. It seems to come and go. After rebooting for a 
double-check I just connected fine without the revert, after earlier being 
unable to.

So in my case, it seems to be flakiness, and I can't actually confirm that 
it's due to the same issue.

I'll double- and triple-test some more, but won't revert unless I can 
confirm things better.

			Linus
