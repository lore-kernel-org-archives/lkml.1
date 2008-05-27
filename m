Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYE0PoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYE0PoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756789AbYE0PoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:44:13 -0400
Received: from www.tglx.de ([62.245.132.106]:53757 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbYE0PoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:44:13 -0400
Date: Tue, 27 May 2008 17:43:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: fix updating of ftrace_update_cnt
In-Reply-To: <48386104.6020109@gmail.com>
Message-ID: <alpine.LFD.1.10.0805271741370.3295@apollo.tec.linutronix.de>
References: <48386104.6020109@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Abhishek Sagar wrote:
> Hi Ingo/Steven,
> 
> Ftrace currently maintains an update count which includes false
> updates, i.e, updates which failed. If anything, such failures
> should be tracked by some separate variable, but this patch provides
> a minimal fix.
 
Good catch. Applied, thanks

     tglx
