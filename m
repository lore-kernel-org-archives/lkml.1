Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbZACUZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbZACUZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759650AbZACUZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:25:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36540 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZACUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:25:46 -0500
Date: Sat, 3 Jan 2009 21:27:40 +0100
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
	from unsigned long
Message-ID: <20090103202740.GC1666@elf.ucw.cz>
References: <20090103124400.GA1572@ucw.cz> <20090103201955.186974bb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103201955.186974bb@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-01-03 20:19:55, Alan Cox wrote:
> On Sat, 3 Jan 2009 13:44:00 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > Linux relies on unsigned long to behave like atomic for read/write.
> 
> Actually it isn't that simple and this advice shouldn't be given IMHO.
> 
> unsigned long is not the same as atomic in several respects including
> ordering and caching of the result.

Ok... I keep seeing patches using int/long instead of atomic and
claiming that it is okay.

If it is okay and linux relies on it, it should be documented.

If it is not okay, I guess we should document it, too -- it seems to
be common mistake. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
