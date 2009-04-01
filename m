Return-Path: <linux-kernel-owner+w=401wt.eu-S1765794AbZDAQl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765794AbZDAQl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764553AbZDAQln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:41:43 -0400
Received: from gw.goop.org ([64.81.55.164]:42863 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbZDAQlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:41:42 -0400
Message-ID: <49D39940.80801@goop.org>
Date: Wed, 01 Apr 2009 09:41:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <dada1@cosmosbay.com>, Tejun Heo <htejun@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
References: <49D32212.80607@cosmosbay.com> <49D32DC2.9010003@goop.org> <49D33E80.70802@cosmosbay.com> <20090401161218.GB3859@elte.hu>
In-Reply-To: <20090401161218.GB3859@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>                      : "memory", "cc");
>> }
>>     
>
> Hm, what's your point with pasting this inline function?
>   

He's pointing out the redundant (but harmless) "cc" clobber.

    J
