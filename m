Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZGNRAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZGNRAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbZGNRAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:00:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49672 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbZGNRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:00:42 -0400
Date: Tue, 14 Jul 2009 13:00:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing/filter: Remove empty subsystem and
 its directory
In-Reply-To: <tip-dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0907141259370.32740@gandalf.stny.rr.com>
References: <4A55A8BE.9010707@cn.fujitsu.com> <tip-dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 10 Jul 2009, tip-bot for Xiao Guangrong wrote:

> Commit-ID:  dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c
> Gitweb:     http://git.kernel.org/tip/dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c
> Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> AuthorDate: Thu, 9 Jul 2009 16:22:22 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 10 Jul 2009 11:55:28 +0200
> 
> tracing/filter: Remove empty subsystem and its directory
> 
> Remove empty subsystem and its directory when module unload.
> 
> Before patch:
>  # rmmod trace-events-sample.ko
>  # ls sample
>  enable  filter
> 
> After patch:
>  # rmmod trace-events-sample.ko
>  # ls sample
>  ls: cannot access sample: No such file or directory
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Acked-by: Tom Zanussi <tzanussi@gmail.com>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> LKML-Reference: <4A55A8BE.9010707@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Thanks Xiao!

I've just came back from vacation so I missed acking it. But it looks 
good, and Ingo pulled it in.

-- Steve

