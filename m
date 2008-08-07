Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYHGVXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYHGVXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYHGVWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:22:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47389 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYHGVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:22:29 -0400
Date: Thu, 7 Aug 2008 10:57:33 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: stefano.stabellini@eu.citrix.com, krzysztof.h1@poczta.fm, adaplas@pol.net,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: 2.6.27-rc1: softcursor behaviour changed
Message-ID: <20080807085733.GA1560@elf.ucw.cz>
References: <20080805212004.GA1592@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805212004.GA1592@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> In 2.6.26, this 
> 
>     echo -e "\33[10;5000]\33[11;50]\33[?18;0;136c\33[?102m"
> 
> produces some variation on cursor. on 2.6.27-rc1, I have no cursor at
> all :-(.

The patch that changed it is below... and I must say I liked the old
behaviour better. Unlike blinking, high-brightness background is
actually useful. Can we get that one reverted?

									Pavel

commit 2d04a4a72d7e1519b4838f24bdd4b5d0f3f426dc
tree 2e6278cbc64a338824511c19ad38c7e289fa7112
parent 4a25e41831ee851c1365d8b41decc22493b18e6d
author Stefano Stabellini <stefano.stabellini@eu.citrix.com> Wed, 23
Jul 2008 21:31:48 -0700
committer Linus Torvalds <torvalds@linux-foundation.org> Thu, 24 Jul
2008 10:47:41 -0700

    fbcon: bgcolor fix

    The fourth bit of the background color is the blink property bit,
not the
    intensity bit, as for the foreground color.  Therefore it
shouldn't be
    included in the background color.

    Signed-off-by: Stefano Stabellini
<stefano.stabellini@eu.citrix.com>
    Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
    Cc: "Antonino A. Daplas" <adaplas@pol.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
