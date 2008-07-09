Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYGINQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYGINQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYGINQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:16:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:25881 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYGINQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=PlMPiasjFk9B5bokQU9u7qC6N0lDe4FAWTTxorL28AF83F+Ch3lnVfgcIPYhh39f+b
         JwpP0SSdDghdPJgum40hb+WxZchswXjqbyTUgewBSXxT0BMQOdTxuJtjCVV54B7owaV/
         LD62C6WFyyn3PG8VC+1QHaA1DhH0uajc2ue1I=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
	<486B8B6C.2050109@firstfloor.org>
	<m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org>
	<m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807070901490.11076@woody.linux-foundation.org>
	<20080709130305.GB20768@elte.hu>
Date: Wed, 09 Jul 2008 15:16:15 +0200
In-Reply-To: <20080709130305.GB20768@elte.hu> (Ingo Molnar's message of "Wed,
	9 Jul 2008 15:03:05 +0200")
Message-ID: <m3od57nqow.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

>> Obviously, I'd be even happier if it also went through the normal x86 
>> review cycles (ie Ingo &co), but the current series is largely ack'ed 
>> by me.
>
> applied them to tip/x86/core, for v2.6.27 merging, thanks everyone.
>
> I've added Linus's Acked-by. Vitaly, could you please send your 
> Signed-off-by line, it was missing from the patches. 

It was wrongly set at the very end of post.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

> You can check the 
> current form of the commits via:
>
>  git-pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/core
>
> (the patches changed slightly, there was some merge fallout due to other 
> changes in this area.)

I'll run it through test case and will let you know if something goes
wrong. Thanks.

-- 
wbr, Vitaly
