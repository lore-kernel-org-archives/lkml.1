Return-Path: <linux-kernel-owner+w=401wt.eu-S1751189AbXCNQtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbXCNQtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXCNQtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:49:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbXCNQtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:49:40 -0400
Date: Wed, 14 Mar 2007 09:49:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070314134112.GB13486@elte.hu>
Message-ID: <Pine.LNX.4.64.0703140945530.9690@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <1173879210.31159.30.camel@localhost.localdomain>
 <20070314134112.GB13486@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Ingo Molnar wrote:
> 
> symbolic links perhaps? In that case i'd also introduce a common naming 
> scheme: x86_early_printk.c - to make sure we know it right away that 
> those files are bi-arch.

Hey, I know! This is a radical idea, but what if we put the name at the 
head of the file, and called it

	arch/x86/kernel/early_printk.c

instead? Then we could teach each of i386 and x86-64 to include it from 
that area, and we could put other shared files under the same directory 
hierarchy so that it would be easy to see which ones are shared?

Crazy idea, I know. But I think I saw somebody send out a patch kind of 
like that, so maybe this common naming scheme could be as simple as just 
applying a few patches once they got cleaned up and re-organized some 
more.

			Linus
