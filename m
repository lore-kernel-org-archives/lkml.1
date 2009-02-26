Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZBZOFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZBZOFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZBZOFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:05:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZBZOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:05:01 -0500
Date: Thu, 26 Feb 2009 09:04:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/5] [RFC] copy_strtok_from_user
In-Reply-To: <alpine.DEB.2.00.0902260750500.26792@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0902260900350.26792@gandalf.stny.rr.com>
References: <20090226053240.607719846@goodmis.org> <1235642612.4645.4737.camel@laptop> <20090226122859.GD23099@elte.hu> <20090226123017.GA2041@elte.hu> <alpine.DEB.2.00.0902260750500.26792@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Feb 2009, Steven Rostedt wrote:

> 
> On Thu, 26 Feb 2009, Ingo Molnar wrote:
> > > 
> > > yes. Note that strsep() is the preferred API. (in fact it's 
> > > the only such string API that is in the kernel)
> > 
> > btw., for larger strings we cannot really copy into the kernel i 
> > suspect. We'd have to kmalloc() and that adds overhead, etc.
> > 
> > Nevertheless, copy_strsep_from_user() would be the symmetric API 
> > here.
> 
> OK, I'll rebase again calling it copy_strsep_from_user. And I'll change 
> the implementation to use copy_from_user/strsep

I need to have my first cup of coffee _before_ replying :-p

My first understanding of strsep was correct.  strsep stops at the first 
delimiter. It may be time to add strtok_r into the kernel.

-- Steve

