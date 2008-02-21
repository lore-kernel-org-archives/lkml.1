Return-Path: <linux-kernel-owner+w=401wt.eu-S1763997AbYBUXoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763997AbYBUXoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762057AbYBUXnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:43:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44408 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758747AbYBUXnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:43:07 -0500
Date: Thu, 21 Feb 2008 23:31:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080221233144.6368712c@core>
In-Reply-To: <m3tzk1q3rt.fsf@maximus.localdomain>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	<m3tzk1q3rt.fsf@maximus.localdomain>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 00:38:14 +0100
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > I'm personally of the opinion that a lot of checkpatch "fixes" are 
> > anything but. That mainly concerns fixing overlong lines
> 
> Perhaps we should increase line length limit, 132 should be fine.
> Especially useful with long printk() lines and long arithmetic
> expressions.

Agreed. The fact I'm having to fix bugs introduced by incorrect printk
wrapping confirms that for printk strings at least it is overzealous.

I'm all for it complaining about

  printk(KERN_FOO "<90 chars>", foo, bar + 37);

type bits when the foo, bar should be underneath to be visible but for
straight quoted text too long it should not warn and try to get the text
folded.

Alan
