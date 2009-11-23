Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZKWUcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZKWUcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZKWUcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:32:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54166 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZKWUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:32:05 -0500
Date: Mon, 23 Nov 2009 21:32:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: spitz: suspend/resume broken in pxa tree
Message-ID: <20091123203204.GA26942@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried checking out Eric's pxa tree (I hope I got it right), and 

commit b0bd7b56ff4a0672d11751e4f20505d1cad1e132
Merge: 989eadd 0352170
Author: Eric Miao <eric.y.miao@gmail.com>
Date:   Wed Nov 11 22:51:19 2009 +0800

    Merge branch 'topic/cm-x300' into for-next
    
    Conflicts:
        arch/arm/mach-pxa/cm-x300.c

(which should be current head?) seems to boot ok, but there's no
reaction on power button after suspend :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
