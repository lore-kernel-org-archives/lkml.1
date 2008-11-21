Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYKURXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYKURXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbYKURXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:23:31 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37198 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897AbYKURXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:23:30 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, torvalds@linux-foundation.org, hch@infradead.org,
       mingo@elte.hu, rminnich@sandia.gov, ericvh@gmail.com,
       linux-kernel@vger.kernel.org
In-reply-to: <4926EBD8.6070200@kernel.org> (message from Tejun Heo on Sat, 22
	Nov 2008 02:11:52 +0900)
Subject: Re: [PATCH RESEND] poll: allow f_op->poll to sleep, take #2
References: <491BA16C.30606@kernel.org> <alpine.LFD.2.00.0811151208430.3468@nehalem.linux-foundation.org> <49256CCE.9060107@kernel.org> <E1L3Z5h-0008J7-QN@pomaz-ex.szeredi.hu> <4926EBD8.6070200@kernel.org>
Message-Id: <E1L3Zif-0008SF-S1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Nov 2008 18:23:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008, Tejun Heo wrote:
> For both, I was trying to stay consistent with the environment.  I
> find mixed styles in close proximity much uglier than slightly
> different but consistent style.  Eh... Is the consensus checkpatch or
> die?

I think some common sense can be applied in these cases.  For example
a small amount of offending style in close proximity can be fixed as
well, as long as it doesn't interfere too much with the readability of
the patch.

Miklos
