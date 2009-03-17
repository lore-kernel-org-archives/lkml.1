Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZCQQHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZCQQHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbZCQQHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:07:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39176 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbZCQQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:07:32 -0400
To: mingo@elte.hu
CC: miklos@szeredi.hu, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-reply-to: <20090317152753.GD13895@elte.hu> (message from Ingo Molnar on
	Tue, 17 Mar 2009 16:27:53 +0100)
Subject: Re: wrong timestamps in ftrace?
References: <E1Ljb4V-0005Tz-44@pomaz-ex.szeredi.hu> <20090317152753.GD13895@elte.hu>
Message-Id: <E1Ljbp3-0005Zc-2J@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Mar 2009 17:07:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Ingo Molnar wrote:
> * Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > So according to the timestamps the time difference between the first
> > and last event was just 0.12s, which is rubbish.
> > 
> > This is latest git on a CoreDuo T60 notebook.  Attaching .config and
> > dmesg.
> 
> There's been changes to timestamping in the tracing tree. Could you 
> check whether latest -tip:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> works better for you?

Unfortunately no, it's behaving exatly the same.

# uname -a
Linux tucsk 2.6.29-rc8-tip-02571-g0fcb24f-dirty #9 SMP PREEMPT Tue Mar 17 16:53:41 CET 2009 x86_64 x86_64 x86_64 GNU/Linux

Thanks,
Miklos
