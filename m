Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXD2BFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXD2BFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 21:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXD2BFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 21:05:37 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:40336 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXD2BFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 21:05:35 -0400
Date: Sun, 29 Apr 2007 02:04:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Lang <david.lang@digitalinsight.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Message-ID: <20070429010428.GA8117@srcf.ucam.org>
References: <4630DF19.3060805@kernel.org> <alpine.LFD.0.98.0704261036120.9964@woody.linux-foundation.org> <46339E0C.4070109@tmr.com> <Pine.LNX.4.63.0704281214380.11638@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0704281214380.11638@qynat.qvtvafvgr.pbz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 12:15:50PM -0700, David Lang wrote:

> with dynaticks now in the kernel it may even be possible to have the idle 
> process decide that the next event is far enough away that it should 
> suspend-to-ram until that point.

This would be ideal (and it's broadly what the OLPC guys are aiming for, 
I think), but on most platforms you're looking at at least a second or 
so to resume. As far as I know, we're still looking at ~60 ticks a 
second at best for an average desktop, so that's not going to be a win.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
