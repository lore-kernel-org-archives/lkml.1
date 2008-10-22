Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYJVPmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYJVPmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYJVPl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:41:57 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:64885 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYJVPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=n1UeKlRLdlkYfC/eyrjjnDNMfqerL2Vq+QGyXsx+xXy1RHRmJquxSQiJbVbl5DT3Kj
         0PMHtNDge5y/iSvnGRCsgkTvRbWgM6/SlBZgC6MLZJ2OioFifbAdEAj7ztLRD+4zGAgJ
         pVAf6gDjslX4gkNZDznf7e7PxrsmZvDRd0Bfg=
Message-ID: <48FF49BD.8000608@gmail.com>
Date: Wed, 22 Oct 2008 18:41:49 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] Implement semaphore latency tracer
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com> <1223817124-27239-6-git-send-email-edwintorok@gmail.com> <1223838786.8634.8.camel@lappy.programming.kicks-ass.net> <48F259A7.2030800@gmail.com> <20081022152842.GI23060@elte.hu>
In-Reply-To: <20081022152842.GI23060@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-10-22 18:28, Ingo Molnar wrote:
> hm, but the most common synchronization primitive are mutexes - and 
> those are not covered by your patchset.
>   

Indeed. I've seen a patch from Jason Baron to introduce tracepoints for
mutexes, but the conclusion was that the tracepoints
should be in lockstat instead.

And if lockstat is enabled Peter Zijlstra's 'contend with points' patch
seems to do exactly what I want to.

However I think it would be useful to have (a tracepoints based?)
latency tracker, which can be enabled/disabled at runtime,
and which doesn't add any data to the mutex/semaphore structures.
My patchset was a first attempt towards that, but it seems that such use
of tracepoints is not welcome at this time?

Please tell me if I should continue working on this, or if I my patches
are designed totally on the wrong way.

Best regards,
--Edwin
