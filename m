Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZJHPqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZJHPqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbZJHPqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:46:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758612AbZJHPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:46:08 -0400
Date: Thu, 8 Oct 2009 08:44:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH] kmap_atomic_push
In-Reply-To: <1255016123.17055.17.camel@laptop>
Message-ID: <alpine.LFD.2.01.0910080844030.3432@localhost.localdomain>
References: <1255016123.17055.17.camel@laptop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Oct 2009, Peter Zijlstra wrote:
>
> The below patchlet changes the kmap_atomic interface to a stack based
> one that doesn't require the KM_types anymore.

I think this is how we should have done it originally.

That said, if we do this, I'd hate to have the "push" and "pop" parts to 
the name. They don't really add a whole lot.

		Linus
