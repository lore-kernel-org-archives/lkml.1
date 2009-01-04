Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZADXbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZADXbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZADXbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:31:05 -0500
Received: from thunk.org ([69.25.196.29]:49102 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZADXbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:31:03 -0500
Date: Sun, 4 Jan 2009 18:30:52 -0500
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104233052.GG22958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
	Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <fa.b62zZFe5e154PhgA+0sdwVXD9F0@ifi.uio.no> <fa.ZTpiSvxEhp3YJDepiUQs+cU0C98@ifi.uio.no> <fa.xvvufQC6zTpU9R6vhDl51DR5V7A@ifi.uio.no> <fa.pkV69eXC76Pb9fnmERdAwXX9OKA@ifi.uio.no> <fa.hQTLXdIllf+hs4yQb092u6fowq0@ifi.uio.no> <49610911.8000204@yahoo.com> <20090104193141.GA22958@mit.edu> <20090104224052.GE1913@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104224052.GE1913@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 11:40:52PM +0100, Pavel Machek wrote:
> Not neccessarily.
> 
> If I have a bit of precious data and lot of junk on the card, I want
> to copy out the precious data before the card dies. Reading the whole
> media may just take too long.
> 
> That's probably very true for rotating harddrives after headcrash...

For a small amount data, maybe; but the number of seeks is often far
more destructive than the amount of time the disk is spinning.  And in
practice, what generally happens is the user starts looking around to
make sure there wasn't anything else on the disk worth saving, and now
data is getting copied off based on human reaction time.  So that's
why I normally advise users that doing a full image copy of the disk
is much better than, say, "cp -r /home/luser /backup", or cd'ing
around a filesystem hierarchy and trying to save files one by one.

Note also that with SD cards, reading is generally non-destructive and
the time it takes to copy off say, 32 GB really isn't that long.

        	    	     	      	      - Ted
