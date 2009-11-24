Return-Path: <linux-kernel-owner+w=401wt.eu-S933411AbZKXVAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbZKXVAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932746AbZKXVAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:00:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932855AbZKXVAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:00:12 -0500
Date: Tue, 24 Nov 2009 21:49:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip v3 1/3] tracepoint: Move signal sending tracepoint
	to events/signal.h
Message-ID: <20091124204943.GA11300@redhat.com>
References: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com> <20091120213115.14708.55068.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120213115.14708.55068.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20, Masami Hiramatsu wrote:
>
> +TRACE_EVENT(signal_generate,
> +
> +	TP_PROTO(int sig, struct siginfo *info, struct task_struct *task),
> +
> +	TP_ARGS(sig, info, p),
                          ^^^
s/p/task/ ?

Oleg.

