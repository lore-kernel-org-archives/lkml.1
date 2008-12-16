Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYLPP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYLPP1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbYLPP1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:27:21 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56314 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbYLPP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:27:20 -0500
To: efault@gmx.de
CC: miklos@szeredi.hu, rjw@sisk.pl, a.p.zijlstra@chello.nl, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-reply-to: <1229437180.5379.76.camel@marge.simson.net> (message from Mike
	Galbraith on Tue, 16 Dec 2008 15:19:40 +0100)
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
	 <T1gm2CtAHBF.A.u6G.g4_QJB@chimera>  <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu>
	 <1229397927.5296.48.camel@marge.simson.net>
	 <E1LCX8h-0001sh-Uo@pomaz-ex.szeredi.hu> <1229437180.5379.76.camel@marge.simson.net>
Message-Id: <E1LCbpI-0002MN-7R@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 16 Dec 2008 16:27:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008, Mike Galbraith wrote:
> We definitely don't want to do that.  Hm.  There are only two commits
> that spring to mind...
> 
> 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69, which is another hope not, and

This didn't fix it either.

> 3f3a490480d8ab96e0fe30a41f80f14e6a0c579d which doesn't seem likely.

This can't be reverted on latest git.

Is there a way to trace what is happening in the scheduler?

Thanks,
Miklos
