Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXINIa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXINIa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 04:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXINIap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 04:30:45 -0400
Received: from styx.suse.cz ([82.119.242.94]:41344 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753298AbXINIao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 04:30:44 -0400
Date: Fri, 14 Sep 2007 10:30:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
In-Reply-To: <20070913220725.f7fb5374.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709141029390.20841@jikos.suse.cz>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
 <20070913220725.f7fb5374.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Andrew Morton wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > i386 and x86_64: randomize brk()
...
> We need a prototype of arch_randomize_brk() in scope for all callers and
> implementations, so that the compiler can perform the appropriate
> typechecking.

You are right, thanks a lot, please fold your fix into my patch.

-- 
Jiri Kosina
SUSE Labs
