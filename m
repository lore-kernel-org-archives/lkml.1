Return-Path: <linux-kernel-owner+w=401wt.eu-S1751681AbZGUHTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbZGUHTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZGUHTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:19:51 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:42531 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGUHTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f9da9dsXZ6tfST46mDe0E0GCEhmqa18+AMk0ITygFwFW8ijySiDV6KQE62YOUWaLVF
         djow81dOhXkxEZo5o/TqVoXEhi8sG1kQW5I463rG2iTdACyOGlXwfygEVNt6/C/7ZBuw
         dqFskKjmQtTMlU5X3YbYoyu86Q1+CtgwtdTr4=
MIME-Version: 1.0
In-Reply-To: <1248111536.15751.9340.camel@twins>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com>
	 <1248109687-7808-6-git-send-email-fweisbec@gmail.com>
	 <1248111536.15751.9340.camel@twins>
Date: Tue, 21 Jul 2009 09:19:49 +0200
Message-ID: <c62985530907210019l1bf7dbeei2215a1ba018dec71@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware 
	breakpoints
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/20, Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Mon, 2009-07-20 at 13:08 -0400, Frederic Weisbecker wrote:
>> +       do_perf_swcounter_event(PERF_TYPE_BREAKPOINT, target, 1, 0,
>> &data);
>
> These breakpoints run from IRQ context?

Hmm, I guess but I'm not sure exactly :-/
