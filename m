Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYKBCn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYKBCn4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYKBCns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:43:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:46174 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYKBCns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:43:48 -0400
Date: Sat, 1 Nov 2008 19:43:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: (BUG?) round_jiffies() is non-monotonic on SMP
Message-ID: <20081101194357.1810f57a@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0811012234590.30060-100000@netrider.rowland.org>
References: <20081101131648.398fe54a@infradead.org>
	<Pine.LNX.4.44L0.0811012234590.30060-100000@netrider.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008 22:36:30 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Sat, 1 Nov 2008, Arjan van de Ven wrote:
> 
> > > Come to think of it, is there any good reason why
> > > round_jiffies() doesn't always round up?  It seems a lot safer.
> > 
> > at the time folks had concerns about making a big error in that
> > direction...
> 
> All right then.  Would it be preferable to add a new
> round_jiffies_up() routine, or to change round_jiffies() so that it
> never rounds down?

I'd prefer the former.
But to be honest.. I would even more prefer the use of range timers ;)
They're in 2.6.28-rc now ... and more power friendly than rounded timers
(although I will readily admit that rounding is just easier)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
