Return-Path: <linux-kernel-owner+w=401wt.eu-S1765655AbXF1Vje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765655AbXF1Vje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbXF1Vj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:39:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43942 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761852AbXF1VjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:39:25 -0400
Date: Thu, 28 Jun 2007 22:39:22 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: William D Waddington <william.waddington@beezmo.com>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070628213922.GG21478@ftp.linux.org.uk>
References: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no> <oor483d2nqn6ae728com1v7v56g0ksotov@4ax.com> <4683983E.5020103@aitel.hist.no> <4683D3B0.1040708@beezmo.com> <20070628173051.4a3422c0@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628173051.4a3422c0@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 05:30:51PM +0100, Alan Cox wrote:
 
> > My (mild) beef is more like what I take to be Al's point: it feels like
> > there is a kind of hostility toward out-of-tree maintainers.  Why not
> 
> Some of that comes about because a lot of them are out of tree
> maintaining non-free stuff, shipping binary products - often entirely
> binary without a Linux or GPL label - until the man in black catches them
> and sues them in Germany.
 
Some, but not all, and you know damn well where the rest is coming
from (kABI is a four-letter word and anything that smells like
a slippery slope towards that in mainline kernel is not a good
idea, to put it very mildly).

It's really very simple:
	(1) There are too many exports
	(2) "should not break any code that uses only exported symbols" is
a very strong constraint.  Too strong to be feasible.
	(3) That constraint has become too strong because module authors
kept adding exports.
	(4) Unless the number of exports is trimmed by at least 1--1.5
orders of magnitude, forget about any such promises.
	(5) Trimming it down is unacceptable for module authors - the same
people who'd created that coprostalagmite in the first place and who keep
asking for such promises.

What can one do?  Well, get the code merged or maintain it on your own.
If the subset of exports you are using is relatively sane, the latter
option will cause you relatively little PITA.  If it's not, well, at least it
doesn't become a pain in our arses...
