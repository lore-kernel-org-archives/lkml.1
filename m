Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbXLHWMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbXLHWMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbXLHWMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:12:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41154 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbXLHWMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:12:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Date: Sat, 8 Dec 2007 23:30:53 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland Dreier <rolandd@cisco.com>,
       Takashi Iwai <tiwai@suse.de>
References: <200712080340.49546.rjw@sisk.pl> <20071208014241.f4b138e0.akpm@linux-foundation.org> <20071208194042.GO17037@thunk.org>
In-Reply-To: <20071208194042.GO17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712082330.54259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 of December 2007, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 01:42:41AM -0800, Andrew Morton wrote:
> > > Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
> > > Submitter	: Roland Dreier <rdreier@cisco.com>
> > > References	: http://lkml.org/lkml/2007/11/8/255
> > > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
> > > Handled-By	: 
> > > Patch		: 
> > 
> > Takashi had a patch and that has been merged.  AFAIK this regression
> > has been fixed and we're left with a new but harmless warning.
> > 
> > However Roland reported other problems and it appears that the trail went
> > cold (http://lkml.org/lkml/2007/11/14/251)
> > 
> > Ted was hitting some of the same problems but that trail appears to also
> > have gone cold (http://lkml.org/lkml/2007/11/23/17).
> 
> Actually, not gone cold, but I stopped posting about it because it's
> been solved and I thought agreement had been reached that it should be
> pushed to mainline before 2.6.25.
> 
> I am very happily running with Ingo's "snd hda suspend latency:
> shorten codec read" patch, which was originally intended to speed up
> resuming from hibernation, but which as I discovered, also has the
> nice side effect of eliminating the reported error.  
> 
> On 11/23, Takashi replied to my note (http://lkml.org/lkml/2007/11/23/17)
> and suggested that Jaroslav push this patch to Linus immediately
> instead of waiting for 2.6.25, since it appearly solves two problems
> with one stone.  However, I just checked, as of Linus's public, and
> Ingo's patch is *not* in mainline.
> 
> However, as far as I am concerned, Ingo's patch, first posted to LKML
> here: http://lkml.org/lkml/2007/11/16/66 should be listed as fixing
> the above regression.  Rafael, could you please make a note of this in
> your regression list,

Done, thanks.

> and could we please get this patch pushed into mainline?
