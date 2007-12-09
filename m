Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbXLICP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbXLICP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 21:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXLICPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 21:15:49 -0500
Received: from THUNK.ORG ([69.25.196.29]:34859 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbXLICPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 21:15:49 -0500
Date: Sat, 8 Dec 2007 21:15:44 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Roland Dreier <rolandd@cisco.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071209021544.GY17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Roland Dreier <rolandd@cisco.com>,
	Takashi Iwai <tiwai@suse.de>
References: <200712080340.49546.rjw@sisk.pl> <20071208014241.f4b138e0.akpm@linux-foundation.org> <20071208194042.GO17037@thunk.org> <200712082330.54259.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712082330.54259.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 11:30:53PM +0100, Rafael J. Wysocki wrote:
> On Saturday, 8 of December 2007, Theodore Tso wrote:
> > However, as far as I am concerned, Ingo's patch, first posted to LKML
> > here: http://lkml.org/lkml/2007/11/16/66 should be listed as fixing
> > the above regression.  Rafael, could you please make a note of this in
> > your regression list,
> 
> Done, thanks.

Great, thanks.  I should add that technically this wasn't a regression
since I had been seeing this since before 2.6.23.  Also, it isn't a
big deal, since aside from noise in the syslog, falling back to
polling more doesn't make any functional or user-visible difference
(although I guess it's less efficient).  

Regardless of whether it is a regression, it would be nice to get the
patch applied and and this issue fixed for 2.6.25!

					- Ted
