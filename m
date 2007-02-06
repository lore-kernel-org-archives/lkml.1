Return-Path: <linux-kernel-owner+w=401wt.eu-S1751678AbXBFOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbXBFOg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 09:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXBFOg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 09:36:56 -0500
Received: from lazybastard.de ([212.112.238.170]:43907 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXBFOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:36:55 -0500
Date: Tue, 6 Feb 2007 13:52:49 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070206135249.GB4566@lazybastard.org>
References: <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> <1170710272.29759.894.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> <1170711587.29759.909.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> <1170712393.29759.925.camel@pmac.infradead.org> <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> <20070205143110.fca62b57.randy.dunlap@oracle.com> <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 February 2007 15:09:15 -0800, Linus Torvalds wrote:
> 
> Why? You could *trivially* have a tool tell you. Make "xconfig" or 
> something just pop up a window saying "sorry, you can't disable SCSI, 
> because you've got ATA enabled, and ATA wants SCSI".

That would be useful for both select and depend, as many have pointed
out.  And ignoring the fairly subjective "be nice" part, either select
or depend can completely get removed once the tools have it.

What I disagree with is the *trivially* part.  For one, the problem is
known for some time and has annoyed enough people, yet we don't have
patches yet.  Secondly, we'd need patches for most, if not all tools.
Not having used "xconfig" for the last eight years, I doubt that you'd
reach a majority of users with any of the plethora of make *config
targets.

We _need_ this support and I welcome anyone getting his/her hands dirty
writing it up.

Jörn

-- 
Fantasy is more important than knowledge. Knowledge is limited,
while fantasy embraces the whole world.
-- Albert Einstein
