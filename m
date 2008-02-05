Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbYBEPq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbYBEPq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYBEPqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:46:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34008 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758133AbYBEPqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:46:46 -0500
Date: Tue, 5 Feb 2008 16:46:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Hugh Dickins <hugh@veritas.com>, Jiri Kosina <jkosina@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205154648.GA24331@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <Pine.LNX.4.64.0802051243240.542@blonde.site> <20080205070001.7bc8058f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205070001.7bc8058f@laptopd505.fenrus.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > In my usual dither, I'm rather hoping Arjan will have a clear answer.
> 
> 
> setarch works. If the apps come in source form they need fixing anyway (since I'd not be
> surprised of current gcc reorders variables), if not.. we only have 2 cases,
> the other case was the build process of emacs (which got fixed 5
> years ago).

uemacs ... broken with randomization
colums, sss ... local programs, broken with randomization
procinfo ... broken, randomization makes it die sooner.
mikmod ... broken with randomization
bsdsed ... broken with randomization
...
Should I test few more?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
