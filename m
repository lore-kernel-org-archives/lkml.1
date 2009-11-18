Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZKRQdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZKRQdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757791AbZKRQdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:33:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772AbZKRQdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:33:01 -0500
Message-ID: <4B0421A2.1080400@redhat.com>
Date: Wed, 18 Nov 2009 11:32:34 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/3] tracepoint: Add signal events
References: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com> <20091118030706.EB93EA8C@magilla.sf.frob.com>
In-Reply-To: <20091118030706.EB93EA8C@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I would add the siginfo_t * argument to each of these tracepoints.

I see. Is it OK to record only si_errno and si_code? because si_signo
might be as same as sig.

> In 2/3 this comment:
>
> +		/* Trace the actual delivered signals including SIG_IGN.*/
>
> might be slightly misleading.  In most cases SIG_IGN signals won't make it
> this far.  The same is true of SIG_DFL signals whose default action is to
> ignore.  So one should be clear that trace_signal_deliver() is by no means
> expected to get all SIG_IGN signals that are otherwise eligible for delivery.

Ah, thank you for noticing. I'll remove the last words.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

