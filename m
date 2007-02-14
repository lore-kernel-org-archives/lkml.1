Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbXBNEml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbXBNEml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 23:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932302AbXBNEmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 23:42:40 -0500
Received: from 1wt.eu ([62.212.114.60]:2414 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbXBNEmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 23:42:40 -0500
Date: Wed, 14 Feb 2007 05:42:32 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070214044232.GC943@1wt.eu>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213142010.GA638@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo !

On Tue, Feb 13, 2007 at 03:20:10PM +0100, Ingo Molnar wrote:
> I'm pleased to announce the first release of the "Syslet" kernel feature 
> and kernel subsystem, which provides generic asynchrous system call 
> support:
> 
>    http://redhat.com/~mingo/syslet-patches/
> 
> Syslets are small, simple, lightweight programs (consisting of 
> system-calls, 'atoms') that the kernel can execute autonomously (and, 
> not the least, asynchronously), without having to exit back into 
> user-space. Syslets can be freely constructed and submitted by any 
> unprivileged user-space context - and they have access to all the 
> resources (and only those resources) that the original context has 
> access to.

I like this a lot. I've always felt frustrated by the wasted time in
setsockopt() calls after accept() or before connect(), or in multiple
calls to epoll_ctl(). It might also be useful as an efficient readv()
emulation using recv(), etc...

Nice work !
Willy

