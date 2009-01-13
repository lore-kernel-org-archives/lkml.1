Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbZAMOGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbZAMOGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZAMOGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:06:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:39873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760846AbZAMOGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:06:36 -0500
Message-ID: <496C9FB7.9050907@kernel.org>
Date: Tue, 13 Jan 2009 23:05:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Subject: Re: [PATCHSET linux-2.6-x86:tip] x86: make percpu offsets zero-based
 on SMP
References: <1231843097-18003-1-git-send-email-tj@kernel.org>	 <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>
In-Reply-To: <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 14:05:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
> I've been working on a patchset that does something similar, but
> eliminating the PDA completely.  The start is already in tip/x86/pda.
> The plan is to change all PDA variables to be normal per-cpu
> variables, merging with 32-bit where possible.

I think the two changes aren't exclusive at all.  The order of things
could be different but in the end, yeah, zero-based percpu symbols w/
mostly empty pda is the goal.

> Once the PDA is empty, I'll base %gs at the start of the per-cpu
> area.  I've been working out the bugs with the last patch
> (zero-basing the percpu area) before submitting, but I probably
> won't have the time until this weekend to polish it off.  I could
> submit all but the last patch if you'd like.

Any chance you can rebase those patches on top of mine?  If you don't
have time, just send them to me, I'll try to integrate them this week.

> They are functionally correct, but because the per-cpu area isn't
> zero-based yet the generated code is a bit bloated due to having to
> calculate the delta for the %gs offset.

BTW, what did you do about the dreaded stack_canary?

Thanks.

-- 
tejun
