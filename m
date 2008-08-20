Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbYHTQLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbYHTQLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbYHTQKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:10:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425AbYHTQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:10:15 -0400
Date: Wed, 20 Aug 2008 12:10:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Kacur <jkacur@gmail.com>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rt Kconfig.preempt fixes
In-Reply-To: <520f0cf10808010639y4c1a19a7kff429827d26dc8e9@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808201207470.27481@gandalf.stny.rr.com>
References: <520f0cf10808010639y4c1a19a7kff429827d26dc8e9@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, John Kacur wrote:

> This is a non-critical patch, that makes configuring an rt kernel a
> little nicer.
> Comments are welcome of course.
> 
> Signed-off-by: John Kacur <jkacur at gmail dot com>
> 
> This patch makes the following changes.
> 1. Hides the visibility of PREEMPT_SOFTIRQS and PREEMPT_HARDIRQS if PREEMPT_RT
> (Complete Preemption) is choosen, since these values are then set (selected) to
> be "y".
> 
> 2. Changes the PREEMPT_HARDIRQS to depend on PREEMPT_SOFTIRQS instead of
> forcing PREEMPT_SOFTIRQS to y if PREEMPT_HARDIRQS is choosen. (this is somewhat
> an abuse of select)
> 
> 3. Minor spelling fix. (tat to that)
> 


Hi John,

Thanks, but instead of this:

 depends on PREEMPT_RT != y

could you do:

 depends on !PREEMPT_RT


-- Steve

