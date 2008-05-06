Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbYEFTpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbYEFTpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbYEFTpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:45:09 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46823 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYEFTpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:45:07 -0400
Date: Tue, 6 May 2008 20:43:48 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
In-Reply-To: <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805062039090.11647@blonde.site>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
 <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site>
 <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Linus Torvalds wrote:
> On Tue, 6 May 2008, Hugh Dickins wrote:
> > 
> > Not-yet-Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> Ok, please let me know when there is a final patch I can apply,

Thanks to Ingo for all his testing, but thanks to you for holding
off: I just now thought to see what a hugetlb "pmd" looks like,
and it does NOT look quite as my tightened pmd_huge() expected -
I've had to drop that part of the patch.  Final patch, to longer
Cc list, follows now.

Hugh
