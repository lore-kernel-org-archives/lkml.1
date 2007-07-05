Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbXGEA14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbXGEA14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXGEA1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:27:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37870 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756074AbXGEA1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:27:48 -0400
Date: Thu, 5 Jul 2007 02:27:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: Paul Mackerras <paulus@samba.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: The big suspend mess
Message-ID: <20070705002747.GA2952@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031456.40890.rjw@sisk.pl> <1183497290.3388.4.camel@localhost.localdomain> <200707032332.49694.rjw@sisk.pl> <18059.5165.861038.392332@cargo.ozlabs.ibm.com> <20070704221952.GM3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704221952.GM3492@stusta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> IMHO the suspend code is currently way too much of a moving target which 
> results in this mess.
> 
> The correct order seems to be:

0. Get someone to sign up as a maintainer for suspend, so we have
someone to blame for the mess? :-)

> 1. agree on what the suspend code as a whole should look like
> 2. implement this
> 3. fix ALL drivers to work at least as good as they do today
> 4. get it tested in -mm
> 5. fix all bugs people run into
> 6. submit it for inclusion in Linus' tree
> 7. quickly work on the most likely big amount of bug reports
> 
> Step 1 is the most important one - evolving code is often something 
> good, but in this case with different people trying to evolve the 
> suspend code in different directions it simply results in a big mess.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
