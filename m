Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYHQWNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYHQWNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbYHQWNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:13:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40347 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbYHQWM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:12:59 -0400
Date: Mon, 18 Aug 2008 00:12:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Paris <eparis@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon	access scanning
Message-ID: <20080817221258.GC21112@atrey.karlin.mff.cuni.cz>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218769209.16613.31.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> And I still don't get this 'mmap problem' that I don't solve that
> libmalware magically solves.  What?  don't use mmap?  I certainly hope
> not.

Don't use mmap, it is as simple as that. AFAICS mmap(MAP_SHARED) --
which is basically shared memory -- is fundamentally incompatible with
reliable virus scanning.

...or do you have a reasonable solution for mmap?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
