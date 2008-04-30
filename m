Return-Path: <linux-kernel-owner+w=401wt.eu-S1762677AbYD3Wkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677AbYD3Wkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbYD3Wj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:39:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47009 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934025AbYD3WjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:39:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 00:39:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <20080430135405.ddc42075.akpm@linux-foundation.org> <20080430221936.GA27292@elte.hu> <20080430.152227.23100100.davem@davemloft.net>
In-Reply-To: <20080430.152227.23100100.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010039.02451.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 1 May 2008 00:19:36 +0200
> 
> > The same goes in the other direction as well - you were just hit by 
> > scheduler tree related regressions that were only triggered on your 
> > 128-way sparc64, but not on our 64way x86 and smaller boxes.
> 
> You keep saying this over and over again, but the powerpc folks hit
> this stuff too.

Well, I think that some changes need some wider testing anyway.

They may be correct from the author's point of view and even from the knowledge
and point of view of the maintainer who takes them into his tree.  That's
because no one knows everything and it'll always be like this.

Still, with the current process such "suspicious" changes go in as parts of
large series of commits and need to be "rediscovered" by the affected testers
with the help of bisection.  Moreover, many changes of this kind may go in from
many different sources at the same time and that's really problematic.

In fact, so many changes go in at a time during a merge window, that we often
can't really say which of them causes the breakage observed by testers and
bisection, that IMO should really be a last-resort tool, is used on the main
debugging techinque.
