Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbYKWJYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbYKWJYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYKWJYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:24:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:62452 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbYKWJYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:24:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oAo9X/ILJsym1toGkmXh2xQ6TBCzeNfREbPSiYa33gOOScoQ5Y88Rb0XrpSFSBR0tE
         K/n8GA9qdvkY5hEiQhrA6ZPs3r2zoaRZgBxVObnWYKG+yAhu0K9Wqhc1GU1Jv3HmvMlG
         zKXBtMWyvfxKzApYpMwIT0jWxugS6dtF18c8E=
Message-ID: <4929214A.6010705@gmail.com>
Date: Sun, 23 Nov 2008 11:24:26 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/2] tracing: userspace stacktraces
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <20081123082630.GC30453@elte.hu>
In-Reply-To: <20081123082630.GC30453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-23 10:26, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> Hi,
>>
>> I am resending my patches, differrences from previous send:
>> * fixed some style issues
>> * introduce seq_print_user_ip helper
>> * make mangle_path global and document
>> * use mangle_path instead of abusing seq_file in trace_seq_path
>> * fix subject line and commit messages
>>
>> These patches apply on top of tip/master,
>> commit 50598e26c1360d4c0edcabc50035d084ee8d3d70
>>
>> Török Edwin (2):
>>   tracing: add support for userspace stacktraces in tracing/iter_ctrl
>>   tracing: identify which executable object the userspace address
>>     belongs to
>>
>>  Documentation/ftrace.txt     |   16 ++++-
>>  arch/x86/kernel/stacktrace.c |   57 +++++++++++++++
>>  fs/seq_file.c                |   14 ++++-
>>  include/linux/seq_file.h     |    1 +
>>  include/linux/stacktrace.h   |    8 ++
>>  kernel/trace/trace.c         |  165 ++++++++++++++++++++++++++++++++++++++++++
>>  kernel/trace/trace.h         |   10 +++
>>  7 files changed, 269 insertions(+), 2 deletions(-)
>>     
>
> applied to tip/tracing/stack-tracer - thanks Edwin!
>
> I've got a few comments about certain details - please send delta 
> patches on top of these patches to fix those.

Thanks for the review Ingo,

The last commit I see is f8d56f1771e4867acc461146764b4feeb5245669, Sun
Oct 26 16:42:18 2008 -0700, am I looking at the wrong place?

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=tracing/stack-tracer

Best regards,
--Edwin
