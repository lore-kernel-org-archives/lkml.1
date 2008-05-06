Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbYEFMGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbYEFMGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYEFMGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:06:05 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52040 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751123AbYEFMGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:06:03 -0400
Date: Tue, 6 May 2008 08:05:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-ext4@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: Problem mounting ext2 using ext3?
Message-ID: <20080506120544.GB6918@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>, Jan Kara <jack@suse.cz>
References: <Pine.LNX.4.64.0805052304280.3160@anakin> <20080505222623.GA8357@mit.edu> <19f34abd0805060026m138bf3dfo87dbf303362d69ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805060026m138bf3dfo87dbf303362d69ca@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 09:26:30AM +0200, Vegard Nossum wrote:
> 
> I posted a very similar problem a couple of days ago:
> http://www.nabble.com/BUG-in-ext3_sync_fs-td16999997.html
> 
> to which I got zero replies. Can I close this in my internal bugzilla
> as dup/"not my fault"? The stacktrace looks very similar. This was
> also ext2 fs mounted (apparently) by ext3 code.

Yeah, sorry, I didn't have network access when I looked at your
e-mail, and so I didn't see the stack trace until you pointed at the
mail message again.  Because you mentioned a USB stick, I assumed it
was the problem with a USB stick getting pulled or being loose causing
an I/O error leading to an oops problem, and I missed the hint of the
problem occurring in the ext3 code when you were using an ext2
formattem.  Fortunately when Geert reported the bug a second time, I
was less dense at the time, and figured it out quickly.  :-)

							- Ted
