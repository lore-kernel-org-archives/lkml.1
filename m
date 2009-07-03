Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZGCQKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZGCQKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZGCQJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:09:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45431 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756369AbZGCQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:09:57 -0400
Date: Fri, 3 Jul 2009 17:11:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703171117.574677de@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703154845.GB13580@elte.hu>
References: <20090703091655.GB3902@elte.hu>
	<20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
	<20090703095432.GC21141@elte.hu>
	<20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	<20090703102234.GA32128@elte.hu>
	<20090703114431.37abd528@lxorguk.ukuu.org.uk>
	<20090703131727.GA3207@elte.hu>
	<20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	<20090703144754.GA13246@elte.hu>
	<20090703160230.093e422c@lxorguk.ukuu.org.uk>
	<20090703154845.GB13580@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So did i get you right that in your opinion sending and writing 
> clean code is a 'bogus standard'? Sorry about trying to interpret 
> you here, i have no choice because you did not reply to my question.

Your definition of "clean code" being ?

> I thought the obvious portions of Documentation/CodingStyle applied 
> to everyone - so it applies to you only if you like it?

CodingStyle is a guide - it applies as a guide to people. It's also lower
priority than working code. Which is why for example we have staging.
Linus pretty clearly ruled where the priorities were I think in accepting
staging.

Now my pending queue has a collection of patches that make the
CodingStyle script whine. I don't care because they improve the cyclades
driver and they are heading in the right direction. Funnily enough none
of the vt patches pending make it moan at all having just checkpatched
them for amusement.

I have every intention of sending them upstream because the patch author
has the technical details right, they make the driver better and they fix
bugs.

vt has 329 codingstyle complaints. Most of that code hasn't changed in
years so a policy of pointless macdinking new patches won't change it but
will mess up the internally consistent style. Instead when vt is settled
down and cleaned up it can have a single cleanup pass. Which is what
happened to various of the tty files as they reached that state.

I could whine about spaces and make the author rewrite them and rework
them so that they made the cyclades driver suffer random weird changes
between its format and CodingStyle but would that actually be a
productive use of anyones time - no.

I don't care if you want to run a policy where you refuse x86 improvements
because there is a misplaced space. If it makes you happy so be it. OTOH
I am not going to drive people away from contributing to the kernel by
forgetting that CodingStyle is a guide, or that a lot of existing kernel
code doesn't follow it and is best patched by keeping it in its original
style.

The other thing CodingStyle is doing now is creating code which is utterly
crap but passes the CodingStyle file because some poor low paid sod in a
software shop somewhere has been told to supply a Linux driver that
passes CodingStyle. Note one that is any good, not one that is following
any Linux code guidelines, not even one that is tested. Instead its become
this monster that less Linux literate software businesses are using to
sign off contracts with in some expectation that "hey it passes
CodingStyle it'll go in" and get outraged when it's refused.

If you want to fix the tty layer to be coding style perfect then send
patches, but there are tons of coding style problems in arch/x86 if you
feel so strongly about it.

Alan
