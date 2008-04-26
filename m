Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbYDZQac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbYDZQac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYDZQaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:30:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759109AbYDZQaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:30:17 -0400
Date: Sat, 26 Apr 2008 09:28:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 4/5] debugobjects: add timer specific object debugging
 code
Message-Id: <20080426092847.318a4fe0.akpm@linux-foundation.org>
In-Reply-To: <20080321200321.731058197@linutronix.de>
References: <20080321200300.310393657@linutronix.de>
	<20080321200321.731058197@linutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 20:26:28 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:

> Add calls to the generic object debugging infrastructure and provide
> fixup functions which allow to keep the system alive when recoverable
> problems have been detected by the object debugging core code.
> 

This has run afoul of the new

http://ozlabs.org/~rusty/kernel/rr-latest/misc:timer-typesafe.patch

I don't know if Rusty intends that for 2.6.26.  Probably not, given its
infancy.  So I'll locally revert that change from Rusty's tree to clear the
way for a clean merge of
debugobjects-add-timer-specific-object-debugging-code.patch.


