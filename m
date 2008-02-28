Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYB1HCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYB1HCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYB1HCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:02:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42315 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYB1HCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:02:38 -0500
Date: Thu, 28 Feb 2008 08:03:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080228070302.GA26007@elf.ucw.cz>
References: <20080227221033.GR17932@hjernemadsen.org> <200802272319.12246.rjw@sisk.pl> <20080228064756.GT17932@hjernemadsen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228064756.GT17932@hjernemadsen.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-02-28 07:47:56, Klaus S. Madsen wrote:
> On Wed, Feb 27, 2008 at 23:19:11 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, 27 of February 2008, Klaus S. Madsen wrote:
> > > Hi all,
> > > 
> > > 	I have a Thinkpad T61p, which I'm able to suspend with s2ram on
> > > Linux 2.6.24.3. However when I try to suspend it on 2.6.25-rc3, s2ram
> > > dies after changing to vt1, with a segfault. I'm using s2ram from cvs,
> > > and libx86 version 0.99 from http://www.codon.org.uk/~mjg59/libx86/.
> > 
> > There's a known suspend problem with 2.6.25-rc3 that has been fixed
> > already in the Linus' tree.  Can you test the current head of the
> > Linus' tree, please?
> I've tested the head of Linus' git as of this morning, and the problem
> still exists. Note however, that I don't even get to the suspend part,
> as s2ram crashes before it initiates the kernel part of STR.

Yes, looks like ingo broke vm86 emulation, or something like that...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
