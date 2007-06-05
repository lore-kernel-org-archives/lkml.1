Return-Path: <linux-kernel-owner+w=401wt.eu-S1763488AbXFEQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763488AbXFEQ6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXFEQ6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:58:32 -0400
Received: from www.osadl.org ([213.239.205.134]:55047 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006AbXFEQ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:58:32 -0400
Subject: Re: FUTEX_CMP_REQUEUE_PI is not quite there
From: Thomas Gleixner <tglx@linutronix.de>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
In-Reply-To: <46455A67.8040203@redhat.com>
References: <46455A67.8040203@redhat.com>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 18:58:27 +0200
Message-Id: <1181062707.4404.119.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 23:10 -0700, Ulrich Drepper wrote:
> I hooked up FUTEX_CMP_REQUEUE_PI here and got a kernel crash.  No serial 
> console so this is the output of the screen after the machine stopped.
> 
> This is of course on x86-64.  Compiled from a rawhide-ified upstream 
> kernel from two days ago.
> 
> The situation is the we requeue from a non-PI futex to a PI futex.  We 
> might now actually want to change the condvar implementation to use
> internally a PI futex if the mutex in use is PI, too, but this kind of 
> mismatch can still happen.  I can provide binaries if necessary.

Can you put the binaries somewhere for download please ? 

I'm looking at the problems, which were reported by Alexey, so I can
look at this as well.

	tglx


