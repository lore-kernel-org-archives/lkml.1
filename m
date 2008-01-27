Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbYA0GC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbYA0GC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYA0GBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:01:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbYA0GBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:01:20 -0500
Date: Sat, 26 Jan 2008 22:01:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] [KGDB] core code cleanups
Message-Id: <20080126220106.4c1c2d5b.akpm@linux-foundation.org>
In-Reply-To: <20080125222836.GA24708@elte.hu>
References: <479A5C35.6040605@windriver.com>
	<20080125222836.GA24708@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 25 Jan 2008 23:28:36 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Jason Wessel <jason.wessel@windriver.com> wrote:
> 
> > This patch is against the x86-git which included the kgdb core.
> > 
> > Per review request from the x86-git maintainers, the kgdb-core has had 
> > the kgdb_handle_exception() separated into individual functions.  This 
> > patch does nothing other than re-organize the code.  There are no 
> > functional kgdb changes.
> > 
> > kgdb_handle_exception now calls gdb_serial_stub() to handle the 
> > debugger communications.  The gdb_serial_stub() has call out to sub 
> > handlers for all the major gdb serial packet types.
> 
> thanks Jason, i have applied your cleanups to x86.git.
> 

I don't recall having actually seen the kgdb patches recently.  Have they
had a suitable level of review?

In particular, as the plan is to migrate all kgdb-enabled architectures
onto the generic kgdb core (yes?), have the owners of the eligible
architectures actually taken a look at what we'll be asking of them?
