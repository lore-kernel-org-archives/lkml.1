Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYGHXIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYGHXIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYGHXH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:07:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40010 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbYGHXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:07:59 -0400
Date: Wed, 9 Jul 2008 01:08:50 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708230850.GD18195@elf.ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net> <20080708072152.GD1761@elf.ucw.cz> <20080708073818.GA14245@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEFC4@G1W1215.americas.hpqcorp.net> <20080708215002.GA18195@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CF552@G1W1215.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BB8CF552@G1W1215.americas.hpqcorp.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-08 22:19:18, Altobelli, David wrote:
> Pavel Machek wrote:
> > Could you provide the list of commands (at least) so we can be more
> > concrete?
> 
> Unfortunately, I don't believe that I can.  We reviewed this internally,
> and the question of documentation was raised.  The hardware teams

You could at least provide list of high-level functionality.

> > (I assume management processors have pretty similar functionality
> > accross vendors, right?)
> 
> I can't speak for other vendors.

And neither can they speak, because you did not tell us what the iLO
does.

> >> It seems much cleaner to keep the kernel interface simple and opaque
> >> (ie read/write), and handle the details of the commands in user
> >> space. From my limited understanding, I thought that was a common
> >> goal here: move what you can to userspace.
> >
> > We are not _that_ extreme. Yes, keep stuff in userspace is important,
> > but "hide hardware differences" is more important goal.
> 
> That seems like a larger question/goal.  Giving users some consistent
> interfaces to do stuff would be nice, but I'd really like to handle this
> driver on its own.

This driver can't be handled on its own, that would lead to a mess in
future. Sorry. We need more info here.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
