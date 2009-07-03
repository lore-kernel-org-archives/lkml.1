Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZGCS2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZGCS2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbZGCS23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:28:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42680 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756067AbZGCS22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:28:28 -0400
Date: Fri, 3 Jul 2009 19:29:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703192947.7921a515@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703162443.GB21399@elte.hu>
References: <20090703095432.GC21141@elte.hu>
	<20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	<20090703102234.GA32128@elte.hu>
	<20090703114431.37abd528@lxorguk.ukuu.org.uk>
	<20090703131727.GA3207@elte.hu>
	<20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	<20090703144754.GA13246@elte.hu>
	<20090703160230.093e422c@lxorguk.ukuu.org.uk>
	<20090703154845.GB13580@elte.hu>
	<20090703171117.574677de@lxorguk.ukuu.org.uk>
	<20090703162443.GB21399@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       if( tty->count == 1 && port->count != 1) {
> 
> and you pushed that piece of code upstream, and you called 
> checkpatch a religion - so apparently you were not using that tool 
> and apparently you think it's fine to push such changes upstream.

The discussion started about something else - a piece of non-compilable
proposal code you space reviewed and didn't even notice wasn't
compileable or sane.

I'm sort of amused you went back through my commits to find that example,
and its certainly one that should have been fixed in the final submit. I
can't be bothered to write a perl script to checkpatch all your commits
and I suspect they all pass anyway.

I don't have a problem with that specific example you dug up being wrong.
Its the "take a piece of non compileable initial sketch proposal, bitch
about spaces and clearly not even look at the code itself" bit that
bothers me.

If I'd have received "hey thats crap, your vt_waitactive conversion
can't possibly work, and the console events are all off by one" I'd have
understood it and agreed entirely (with or without the space note)

Alan
