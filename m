Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbYCNJar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbYCNJar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbYCNJai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:30:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1080 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752610AbYCNJah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:30:37 -0400
Date: Fri, 14 Mar 2008 10:30:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benny Amorsen <benny+usenet@amorsen.dk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080314093019.GA5966@ucw.cz>
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312133001.1668f40d@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Everyone who has write cache turned on for their hard drives is
> > running in a mode similar to ramback anyway (except for when the file
> > system is set to force writes to the platter, but that is rare).
> > Admittedly, software crashes rarely cause the write cache to be lost,
> > but hardware failures do, practically every time.
> 
> On the contrary - the hard disk cache is managed by the barrier logic in
> the kernel, and the ordering even on failures is fairly predictable.

Well, not even all modern hdds support barriers... It would be really
nice to have _safe_ settings by default here...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
