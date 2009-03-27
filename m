Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZC0LjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZC0LjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZC0Liz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:38:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47394 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZC0Liy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:38:54 -0400
Date: Fri, 27 Mar 2009 12:41:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: private user<->kernel interface in linux-2.6.30, was Re: TOMOYO in
	linux-next
Message-ID: <20090327114148.GE2585@elf.ucw.cz>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <200903270412.n2R4CG7o054009@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903270412.n2R4CG7o054009@www262.sakura.ne.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > That's my main complaint: Documentation.*tomoyo nor
> > Documentation.*TOMOYO does not exist, still this adds a *lot* of new
> > user<->kernel interfaces.
> > 
> > New user<->kernel interaces should be documented and very carefuly
> > reviewed; I don't think that happened here.
> These user<->kernel interface are for TOMOYO's policy management tools,
> not for general userland applications like /bin/bash /usr/sbin/sshd etc.

I do believe all user<->kernel interfaces should be properly
reviewed/documented. We'll have to maintain them forever. Just because
you don't intend them to be used by /bin/bash does not mean people
will not use them; and it does not mean we will not have to carry them
forever.

							Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
