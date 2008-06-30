Return-Path: <linux-kernel-owner+w=401wt.eu-S1763713AbYF3Tk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763713AbYF3Tk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYF3TkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:40:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYF3TkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:40:19 -0400
Message-ID: <4869361B.1050205@redhat.com>
Date: Mon, 30 Jun 2008 15:38:03 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627131534.GB13751@Krystal>
In-Reply-To: <20080627131534.GB13751@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Hi Mathieu,
>>
>> Thank you for making this so soon!
>>
>> Mathieu Desnoyers wrote:
>>> ** note : this patch is submitted for early review. It applies after my
>>> current unreleased 2.6.26-rc8 LTTng patchset. Comments are welcome.
>> Would you mean there is no tree on which we can test this patch?
>>
> 
> It actually applies on top of the following patchset :
> 
> http://ltt.polymtl.ca/lttng/patch-2.6.26-rc8-0.10-pre56.tar.bz2

Thank you,

I think, this tracepoint patch might be better moved before
immediate and LTTng's marking point patches, because current -mm/-next
tree doesn't have immediate, and all marking points are replaced
by tracepoints.

Regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

