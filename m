Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYB0WkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYB0WkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYB0Wjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:39:48 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50217 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbYB0Wjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:39:47 -0500
Date: Wed, 27 Feb 2008 23:40:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080227224010.GB13790@elf.ucw.cz>
References: <20080227221033.GR17932@hjernemadsen.org> <200802272319.12246.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802272319.12246.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-02-27 23:19:11, Rafael J. Wysocki wrote:
> On Wednesday, 27 of February 2008, Klaus S. Madsen wrote:
> > Hi all,
> > 
> > 	I have a Thinkpad T61p, which I'm able to suspend with s2ram on
> > Linux 2.6.24.3. However when I try to suspend it on 2.6.25-rc3, s2ram
> > dies after changing to vt1, with a segfault. I'm using s2ram from cvs,
> > and libx86 version 0.99 from http://www.codon.org.uk/~mjg59/libx86/.
> 
> There's a known suspend problem with 2.6.25-rc3 that has been fixed already
> in the Linus' tree.  Can you test the current head of the Linus' tree, please?

This does not look like known problem, actually... s2ram segfaults
somewhere in emulator...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
