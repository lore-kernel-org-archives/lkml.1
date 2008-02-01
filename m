Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbYBABzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbYBABzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYBABzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:55:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbYBABzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:55:19 -0500
Date: Fri, 1 Feb 2008 12:54:46 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Liam Howlett <howlett@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Pull request: TASK_KILLABLE
In-Reply-To: <1201830304.3087.2.camel@heimdal.trondhjem.org>
Message-ID: <alpine.LFD.1.00.0802011252450.3198@www.l.google.com>
References: <20080129000447.GC31101@parisc-linux.org>  <alpine.LFD.1.00.0801292237480.3505@www.l.google.com>  <20080131234504.GB25967@parisc-linux.org>  <alpine.LFD.1.00.0802011146180.3198@www.l.google.com> <1201830304.3087.2.camel@heimdal.trondhjem.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jan 2008, Trond Myklebust wrote:
> 
> Hmm... The current code won't compile as a module. We're at least going
> to require something like the attached patch.

Ahh, ok, I obviously only tested compiling it in.

No need to make that one-liner function be a GPL-only export, it's not 
like any of the other regular sigpending functions are we export are 
GPL-only either (dequeue_signal() is, but that is because we *really* 
don't want people using that, and it's really about internal signal 
handling behavior).

			Linus
