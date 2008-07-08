Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYGHXkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYGHXkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYGHXjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:39:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47648 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbYGHXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:39:53 -0400
Date: Wed, 9 Jul 2008 01:40:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708234043.GB20773@elf.ucw.cz>
References: <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net> <20080708072152.GD1761@elf.ucw.cz> <20080708073818.GA14245@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEFC4@G1W1215.americas.hpqcorp.net> <20080708215002.GA18195@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CF552@G1W1215.americas.hpqcorp.net> <20080708152631.715092c5.rdunlap@xenotime.net> <CF70AA892F109448AEA269483B3A983903BBB0456F@G1W1215.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BBB0456F@G1W1215.americas.hpqcorp.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-08 23:10:38, Altobelli, David wrote:
> Randy Dunlap wrote:
> >
> > Can you at least point people to the user manual etc. so they can see
> > what commands/functionality are/is available?
> >
> Here's a link to a scripting guide:
> 
> http://h20000.www2.hp.com/bc/docs/support/SupportManual/c00294268/c00294268.pdf

What operating system runs on iLO processors?  Can the sources be
downloaded? (It does awful lot of stuff, like ssh server and web
server...)

And yes, iLO has some functions that overlap with led subsystem and
sensors subsystem. It can also power machine up & down (ACPI
overlap). Plus it has its own TCP/IP stack that can be configured, and
its own user management.

Is iLO the only way how to access certain functions? For example: can
the fan status be determined without talking to iLO?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
