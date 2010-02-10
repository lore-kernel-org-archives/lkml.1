Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab0BJVo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:44:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:47275 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab0BJVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:44:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=M4oz094IfRiZQMWkSxys84chhBwxAR6WjxBeT63tmxxkgJgaZcYG9DCzLshOLNrUTh
         0758FZRyTwGkOzJdtNJvnrablICqtw3Pu0bDBdYSypqI+RHY0kxzyMdyBJazKMjMf1py
         q2jH5ZSsotWwoKKluDZkmE9fLineGQyQeGaxU=
Message-ID: <4B7328D2.8050002@gmail.com>
Date: Wed, 10 Feb 2010 22:44:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Veaceslav Falico <vfalico@redhat.com>
Subject: Re: [PATCH 1/1] kernel core: use helpers for rlimits fix
References: <1265831948-7873-1-git-send-email-jslaby@suse.cz> <20100210121009.a48ed15c.akpm@linux-foundation.org>
In-Reply-To: <20100210121009.a48ed15c.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 09:10 PM, Andrew Morton wrote:
> static void posix_cpu_timers_init_group(struct signal_struct *sig)
> {
> 	unsigned long cpu_limit;
> 
> 	/* Thread group counters. */
> 	thread_group_cputime_init(sig);
> 
> 	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
> 	if (cpu_limit != RLIM_INFINITY) {
> 		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
> 		sig->cputimer.running = 1;
> 	}

FWIW ack.

thanks,
-- 
js
