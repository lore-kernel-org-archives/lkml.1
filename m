Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbZJ0KoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbZJ0KoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZJ0KoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:44:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59594 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752483AbZJ0KoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:44:01 -0400
Date: Tue, 27 Oct 2009 10:45:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
Message-ID: <20091027104524.2cf3f9a5@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.0910262119530.14994@asgard.lang.hm>
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm>
	<200910151942.40259.bzolnier@gmail.com>
	<20091015174932.GA3595@suse.de>
	<200910152020.13080.bzolnier@gmail.com>
	<20091015184656.GA29858@suse.de>
	<alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
	<20091015191641.GB19467@elte.hu>
	<alpine.DEB.2.00.0910151230560.22169@asgard.lang.hm>
	<4AD77C4F.5010307@s5r6.in-berlin.de>
	<alpine.DEB.2.00.0910151250480.22169@asgard.lang.hm>
	<alpine.DEB.2.00.0910262119530.14994@asgard.lang.hm>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this is exactly the 'wants to get rid of' category I mentioned being 
> concerned about below.

Why are you concerned, its dead, its defunct, nobody cares, nobody uses
it. The same is true of a lot of other junk drivers we have and need to
get rid of.

> I don't know what was decided at the kernel summit where this was 
> discussed, how easy is it supposed to be to drop drivers out of the 
> kernel?

If there is someone with the hardware its a trivial git command to put it
back and they can then maintain it, but I'm pretty sure that there won't
be anyone using this ancient hardware and I really doubt the code even
works after the big tty re-arrange.

There is a difference between ancient junk people care about (however
crazy) and stuff that is just dead and slowing real work (and I have
several serial drivers I want to bit bucket such as rio and esp)
