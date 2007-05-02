Return-Path: <linux-kernel-owner+w=401wt.eu-S2993378AbXEBPte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993378AbXEBPte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993358AbXEBPte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:49:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48296 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993378AbXEBPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:49:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dean Nelson <dcn@sgi.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: "partical" kthread conversion
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<20070501084245.GA14364@infradead.org>
	<20070501015141.f09f6dde.akpm@linux-foundation.org>
	<20070502140115.GA23595@sgi.com>
	<m11whzxp0d.fsf@ebiederm.dsl.xmission.com>
	<20070502153727.GA31794@sgi.com>
Date: Wed, 02 May 2007 09:49:05 -0600
In-Reply-To: <20070502153727.GA31794@sgi.com> (Dean Nelson's message of "Wed,
	2 May 2007 10:37:27 -0500")
Message-ID: <m1r6pzw7im.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dean Nelson <dcn@sgi.com> writes:

> I'd typed up some questions for you about the new patch I need to create
> which I'd just sent to you, so I won't repeat them here.
>
> Before proceeding to far with your above changes, you might wait to see
> the proposal that Robin Holt is putting together for a kthread pool.
> I'm not sure how spawning a thread (which involves allocation of the
> task_struct amongst other things, plus scheduling) can beat a wake_up()
> of an already existing thread for cost time-wise.

A reasonable point, although if you don't happen to sleep in the allocations
I suspect time wise it's pretty much a wash.

I have some other reasons I might need the capability of clone a thread
from a non-parent process, and it has the potential to simplify some things
in the kthread case so I'm going to finish investigating, since I believe
I have figured out a path to that target.

Eric
