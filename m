Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYJVTDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYJVTDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYJVTDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:03:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50911 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYJVTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:03:07 -0400
Date: Wed, 22 Oct 2008 15:02:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 01/11] ftrace: handle generic arch calls
In-Reply-To: <20081022115607.c0b3974c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810221500120.25498@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185135.618026303@goodmis.org> <20081022115607.c0b3974c.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Oct 2008, Andrew Morton wrote:

> On Wed, 22 Oct 2008 14:43:14 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +if ($arch eq "x86") {
> > +    if ($bits == 64) {
> > +	$arch = "x86_64";
> > +    } else {
> > +	$arch = "xi386";
> 
> ?
> 
> > +    }
> 
> (how well was this tested?)

I've tested this with !CONFIG_FTRACE, CONFIG_FTRACE & 
!CONFIG_DYNAMIC_FTRACE, and CONFIG_FTRACE & CONFIG_DYNAMIC_FTRACE. I did 
only test this on x86_64, so that explains why the i386 was broken :-(

I'll boot up my i386 box, and start running the tests there too.

-- Steve



