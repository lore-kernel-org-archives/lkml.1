Return-Path: <linux-kernel-owner+w=401wt.eu-S1750726AbXCZLU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750726AbXCZLU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXCZLU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:20:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53959 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbXCZLU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:20:56 -0400
Date: Mon, 26 Mar 2007 03:20:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre.Peiffer@bull.net
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net, Pierre Peiffer <pierre.peiffer@bull.net>
Subject: Re: [PATCH 2.6.21-rc4-mm1 4/4] sys_futex64 : allows 64bit futexes
Message-Id: <20070326032023.0aa5ca7f.akpm@linux-foundation.org>
In-Reply-To: <20070321100542.438317770@bull.net>
References: <20070321095432.207136068@bull.net>
	<20070321100542.438317770@bull.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 10:54:36 +0100 Pierre.Peiffer@bull.net wrote:

> It does not provide the functionality for all architectures (only for x64 for now).

Well that scuppers our chances of getting -mm kernels tested on ia64, s390
and sparc64.  Which is a problem - people do test s390 and ia64 and so these
patches impact the testing quality of everyone else's work.


Do we have a plan to fix this (promptly, please)?

kernel/built-in.o(.text+0x683a2): In function `futex_requeue_pi':
: undefined reference to `futex_atomic_cmpxchg_inatomic64'
