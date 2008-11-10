Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYKJKJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYKJKJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYKJKJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:09:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56702 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbYKJKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:09:16 -0500
Date: Mon, 10 Nov 2008 11:09:15 +0100
From: Pavel Machek <pavel@suse.cz>
To: J?rn Engel <joern@logfs.org>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext2/3 vs. kingston 32G SD card
Message-ID: <20081110100915.GB30504@atrey.karlin.mff.cuni.cz>
References: <20081104110225.GB4514@atrey.karlin.mff.cuni.cz> <20081104114733.GA16036@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104114733.GA16036@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 4 November 2008 12:02:25 +0100, Pavel Machek wrote:
> > 
> > I got 32GB kingston SD card, and am using it with ext2 for storing git
> > trees etc.
> > 
> > Unfortunately, every time I run fsck, I get rather nasty corruption. 
> > I switched it to ext3 now, but I believe I have seen corruption even
> > on volume marked clean, which should be impossible from user error.
> > 
> > If I suspect wrong block device, what are useful tests to run there?
> 
> Not likely in your case, but a number of counterfeited devices are on
> the market.  They contain a much smaller chip inside than is advertised
> plus some logic to return 0x00 when reading from non-existent memory.
> 
> To test for this, simply write 0xff to the complete device and read it
> back.  'hd' is useful, as it compressed the output into four lines for a
> good device and a bit more when you bought crap.

Ok, I switched to ext3 and the card seems to behave now. It seems to
hold the data, so it is probably not fake :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
