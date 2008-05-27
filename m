Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbYE0PmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbYE0PmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbYE0Plx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:41:53 -0400
Received: from www.tglx.de ([62.245.132.106]:53671 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865AbYE0Plw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:41:52 -0400
Date: Tue, 27 May 2008 17:41:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: safe traversal of ftrace_hash hlist
In-Reply-To: <48385B26.7040509@gmail.com>
Message-ID: <alpine.LFD.1.10.0805271740580.3295@apollo.tec.linutronix.de>
References: <48385B26.7040509@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Abhishek Sagar wrote:
> Hi Steven,
 
> I noticed that concurrent instances of ftrace_record_ip() have a
> race between ftrace_hash list traversal during ftrace_ip_in_hash()
> (before acquiring ftrace_shutdown_lock) and ftrace_add_hash().If
> it's so then this should fix it.

Applied. Thanks,

	 tglx
