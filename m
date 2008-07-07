Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbYGGRGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbYGGRGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYGGRGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:06:01 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:1462 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYGGRGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=W9Zrw8deS0k/10x34a4LaR+FyswvMUUzRWn7X0W9IeIlXwyFQg6J8OLdFmrKh65Bvb
         qU3IlBpwSWz+iXx6eg0nkUztiGJWnW0bnPyqFA081njrw3A+cMwyYMfY8ES1kPYHfKGf
         u7Hql27Rn1Kxa4OOqum1oSYA7K3m6eU0Mz8PI=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
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
Date: Mon, 07 Jul 2008 19:05:58 +0200
In-Reply-To: <alpine.LFD.1.10.0807070901490.11076@woody.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 7 Jul 2008 09:21:36 -0700 (PDT)")
Message-ID: <m363rhhbex.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> See? We don't actually care about vma boundaries or anything like that. We 
> just care about the only boundary that matters for faults: the page 
> boundary.

I was thinking about find_vma() for memset, but, yes, it should never
fail in kernel space (unless bug) and find_vma() is unnecessary.
-- 
wbr, Vitaly
