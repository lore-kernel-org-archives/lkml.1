Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYB2LQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYB2LQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYB2LQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:16:10 -0500
Received: from ozlabs.org ([203.10.76.45]:43169 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbYB2LQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:16:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18375.59486.392919.984544@cargo.ozlabs.ibm.com>
Date: Fri, 29 Feb 2008 22:11:26 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
In-Reply-To: <20080228201613.GA30999@elte.hu>
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
	<20080228201315.GA30736@elte.hu>
	<20080228201613.GA30999@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Anything else I can do?
> > 
> > yes, please test the patch below - does it fix the problem?
> 
> (assuming you prefer patches that build, here's an updated one below.)

Is this patch going to add overhead?

On powerpc we use the timebase register, which is synchronized across
CPUs, so if this will add unnecessary overhead, we will want to way to
turn it off on powerpc (assuming this ends up going upstream).

Paul.
