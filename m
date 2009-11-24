Return-Path: <linux-kernel-owner+w=401wt.eu-S933505AbZKXVA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbZKXVA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932827AbZKXVAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:00:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932945AbZKXVAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:00:22 -0500
Message-ID: <4B0C495F.8000002@redhat.com>
Date: Tue, 24 Nov 2009 16:00:15 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip v3 1/3] tracepoint: Move signal sending tracepoint
 to events/signal.h
References: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com> <20091120213115.14708.55068.stgit@dhcp-100-2-132.bos.redhat.com> <20091124204943.GA11300@redhat.com>
In-Reply-To: <20091124204943.GA11300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 11/20, Masami Hiramatsu wrote:
>>
>> +TRACE_EVENT(signal_generate,
>> +
>> +	TP_PROTO(int sig, struct siginfo *info, struct task_struct *task),
>> +
>> +	TP_ARGS(sig, info, p),
>                            ^^^
> s/p/task/ ?

Oops, right.

Thank you for reviewing!

>
> Oleg.
>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

