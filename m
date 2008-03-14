Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYCNTFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYCNTFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYCNTEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:04:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3158 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752402AbYCNTEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:04:50 -0400
Date: Fri, 14 Mar 2008 20:03:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <ric@emc.com>
Cc: Theodore Tso <tytso@mit.edu>, Benny Amorsen <benny+usenet@amorsen.dk>,
       linux-kernel@vger.kernel.org
Subject: writeback cache dangers Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080314190357.GB7151@ucw.cz>
References: <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com> <m3fxutcz2s.fsf@ursa.amorsen.dk> <20080314125656.GA7412@mit.edu> <47DA9DF8.5010600@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA9DF8.5010600@emc.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The ingest rate at the time of a power hit makes a huge 
> difference as well - basically, pulling the power cord 
> when a box is idle is normally not harmful. Try that 
> when you are really pounding on the disks and you will 
> see corruptions a plenty without barriers ;-)

I tried that, and could not get a corrruption. cp -a on big kernel
trees, on sata disk with writeback cache and no barriers... and I
could not cause fs corruption. ext3.

I'd like to demo danger of writeback cache. What should I do?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
