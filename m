Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbZLKQKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbZLKQKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933182AbZLKQK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:10:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932918AbZLKQK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:10:28 -0500
Date: Fri, 11 Dec 2009 08:07:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Vegard Nossum <vegardno@ifi.uio.no>
Subject: Re: [patch 8/9] Documentation: Fix invalid rcu assumptions
In-Reply-To: <13688.1260540024@redhat.com>
Message-ID: <alpine.LFD.2.00.0912110804430.3560@localhost.localdomain>
References: <20091210004703.308396881@linutronix.de> <20091210001308.247025548@linutronix.de> <13688.1260540024@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Dec 2009, David Howells wrote:

> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > -197          * we use RCU protection here
> > +196          * caller must be holding the RCU readlocke
> 
> You mean "readlock" I suspect.

Or maybe he's talking about ye olde readlocke, used widely for OS research 
throughout the middle ages. You still find that spelling in some really 
old CS literature.

			Linus
