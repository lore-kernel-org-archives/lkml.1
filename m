Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZC1MMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZC1MMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 08:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZC1MMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 08:12:33 -0400
Received: from THUNK.ORG ([69.25.196.29]:41352 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbZC1MMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 08:12:33 -0400
Date: Sat, 28 Mar 2009 08:12:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090328121221.GC2155@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bodo Eggert <7eggert@gmx.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cjJsv-3Uu-5@gated-at.bofh.it> <cjKHX-5MF-19@gated-at.bofh.it> <ck7XP-JA-13@gated-at.bofh.it> <ck8h7-18H-1@gated-at.bofh.it> <ck8AA-1y0-7@gated-at.bofh.it> <ck8Kd-20o-7@gated-at.bofh.it> <ckaVR-5o8-9@gated-at.bofh.it> <ckbf4-5M8-7@gated-at.bofh.it> <ckcE8-845-9@gated-at.bofh.it> <E1LnJzS-0001vn-Vf@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LnJzS-0001vn-Vf@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 10:53:26PM +0100, Bodo Eggert wrote:
> data=ordered is a sane way of handling data. Otherwise, the millions
> would change their ext3 to data=writeback.

See the discussion about defaulting to "relatime" (or my preferred,
"noatime") mount option.  It's a very sane thing to do, yet most
people don't use anything other than the defaults.  And now we're told
even most distro's are hesitant to tweak tuning parameters away from
the default.

					- Ted
