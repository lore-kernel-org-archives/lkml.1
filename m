Return-Path: <linux-kernel-owner+w=401wt.eu-S965661AbXDCRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbXDCRM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965663AbXDCRM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:12:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:39338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965661AbXDCRM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:12:27 -0400
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 Apr 2007 20:11:02 +0200
In-Reply-To: <461286D6.2040407@redhat.com>
Message-ID: <p73abxpz5u1.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper <drepper@redhat.com> writes:

> More and more code depends on knowing the number of processors in the
> system to efficiently scale the code.  E.g., in OpenMP it is used by
> default to determine how many threads to create.

There are more uses for it.

>  Creating more threads
> than there are processors/cores doesn't make sense.

There was a proposal some time ago to put that into the ELF aux vector
Unfortunately there was disagreement on what information to put 
there exactly (full topology, only limited numbers etc.) 

My proposal was number of CPUs, number of cores, number of nodes
as three 16 bit numbers.

-Andi
