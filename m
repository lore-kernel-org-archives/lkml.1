Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYBVKfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYBVKfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762471AbYBVKfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:35:14 -0500
Received: from namei.org ([69.55.235.186]:56219 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753475AbYBVKfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:35:13 -0500
Date: Fri, 22 Feb 2008 21:33:52 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
In-Reply-To: <20080222093621.GG327@elte.hu>
Message-ID: <Xine.LNX.4.64.0802222133150.6937@us.intercode.com.au>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au>
 <20080222075950.GB2660@uranus.ravnborg.org> <20080222093621.GG327@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008, Ingo Molnar wrote:

> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > This is on an x86_64 system (actually an Intel SDV -- so it might be 
> > > "special").
> >
> > This is a regression. Can you please revert this commit. We can redo 
> > it wehn the -fstack-protector stuff are properly fixed in x86.
> 
> No!
> 
> James, could you please check whether x86.git#testing:
> 
>    http://people.redhat.com/mingo/x86.git/README
> 
> works fine for you? That has all the current stackprotector fixes. I 
> plan to send a separate pull request with just the stackprotector fixes 
> to Linus, they are looking good in testing so far.

Nope, same problem.

(I followed your instructions in the readme exactly).


- James
-- 
James Morris
<jmorris@namei.org>
