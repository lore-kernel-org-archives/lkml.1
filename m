Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYFQKld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYFQKld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 06:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYFQKlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 06:41:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41685 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbYFQKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 06:40:59 -0400
Date: Tue, 17 Jun 2008 10:44:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: auke-jan.h.kok@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, len.brown@intel.com,
       cpufreq@lists.linux.org.uk, davej@codemonkey.org.uk
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
Message-ID: <20080617084452.GA27101@elf.ucw.cz>
References: <20080606140846.GA9580@ucw.cz> <20080607213918.GC1746@elf.ucw.cz> <20080607145435.4afc9812@infradead.org> <20080616104159.GA28659@elf.ucw.cz> <20080616074337.46d6f411@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616074337.46d6f411@infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > are either of you running gnome-power-manager or kpowersaved ?
> > > sometimes these programs (and more likely, the patches added by a
> > > distro maintainer who doesn't fully realize how power works) tend to
> > > muck with kernel settings around CPU frequency that they have
> > > absolutely no business touching...
> > 
> > In novel bugzilla case ignore_ppc=1 helped, so it seems to be BIOS
> > problem, not userland's...
> 
> well as long as the user doesn't use this for production use... the
> BIOS often reduces frequencies available to deal with thermal
> situations, so it's not a good idea to ignore that.

Not a good idea, but what's the alternative? It seems like BIOS always
leaves him at 800MHz unless he ignores it.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
