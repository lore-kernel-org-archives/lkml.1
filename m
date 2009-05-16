Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbZEPXIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbZEPXIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbZEPXEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:04:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757675AbZEPXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:04:30 -0400
Date: Sat, 16 May 2009 16:03:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.30-rc kills my box hard - and lockdep chains
Message-Id: <20090516160345.5bec42d7.akpm@linux-foundation.org>
In-Reply-To: <1242365555.26820.51.camel@twins>
References: <20090514094951.36fd7333@bike.lwn.net>
	<1242365555.26820.51.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 07:32:35 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-05-14 at 09:49 -0600, Jonathan Corbet wrote:
> > First time gave me:
> > 
> >         BUG: MAX_LOCKDEP_ENTRIES too low!
> > 
> > So I doubled it.  Now I get:
> > 
> > May 14 01:06:55 bike kernel: [38730.804833] BUG: MAX_LOCKDEP_CHAINS
> > too low!
> 
> Ingo recently raised these numbers, from the -tip tree:
> 
> commit d80c19df5fcceb8c741e96f09f275c2da719efef
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue May 12 16:29:13 2009 +0200
> 
>     lockdep: increase MAX_LOCKDEP_ENTRIES and MAX_LOCKDEP_CHAINS
> 
> 
> This will likely make its way upstream soonish.

That patch isn't in linux-next and I can't be bothered going off and
finding it.

Jon said that doubling MAX_LOCKDEP_CHAINS didn't help.  How much did
the above patch increase things by?

