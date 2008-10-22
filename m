Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYJVTER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYJVTER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbYJVTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:03:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57934 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531AbYJVTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:03:46 -0400
Date: Wed, 22 Oct 2008 15:03:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 03/11] ftrace: return error on failed modified text.
In-Reply-To: <20081022115727.ca832616.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810221503040.25498@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185135.952553961@goodmis.org> <20081022115727.ca832616.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Andrew Morton wrote:

> On Wed, 22 Oct 2008 14:43:16 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Return -1 on failed modified text.
> > 
> 
> changelog fails to explain the reason for the change.
> 
> > +	if (__copy_to_user_inatomic((char __user *)ip, new_code,
> > +				    MCOUNT_INSN_SIZE))
> > +		return -1;
> 
> why not -EFAULT?

Indeed, why not.  I'll update it in v2.

-- Steve

