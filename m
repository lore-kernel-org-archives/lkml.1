Return-Path: <linux-kernel-owner+w=401wt.eu-S1764350AbYEGIba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764350AbYEGIba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbYEGIbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:31:15 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42038 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbYEGIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:31:13 -0400
To: mingo@elte.hu
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
In-reply-to: <20080507082405.GA22821@elte.hu> (message from Ingo Molnar on
	Wed, 7 May 2008 10:24:05 +0200)
Subject: Re: audio skipping on 2.6.26-rc1
References: <E1JteVx-0003ro-2h@pomaz-ex.szeredi.hu> <20080507082405.GA22821@elte.hu>
Message-Id: <E1Jtf3N-0003wz-2i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 May 2008 10:31:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On a T60 I get occasional (but very annoying) audio skips while 
> > compiling kernels.  No kernels (as long as I remeber) prior to this 
> > had any similar problems.
> > 
> > It's reproducible, but takes some minutes to get reliably.  Please 
> > don't tell me to bisect it :)
> 
> please try latest -git [it has scheduler interactivity fixes], does it 
> work any better?

OK, will try.

> 
> and also turn off:
> 
> > # CONFIG_CGROUPS is not set
> > CONFIG_GROUP_SCHED=y
> > CONFIG_FAIR_GROUP_SCHED=y
> 
> as it still causes more latencies than it should (even in 
> sched-devel/latest), and the reason is still not understood.

Yeah, the strange thing is that I did have the keyboard repeat
problems with the GROUP_SCHED options on 2.6.25-rc which were
eventually fixed, but this audio skipping is new to 2.6.26.

Miklos
