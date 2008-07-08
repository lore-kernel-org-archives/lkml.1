Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYGHHNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYGHHNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYGHHNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:13:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51109 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYGHHNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:13:13 -0400
Date: Tue, 8 Jul 2008 09:14:08 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: david@lang.hm, "Altobelli, David" <david.altobelli@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708071408.GC1761@elf.ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net> <alpine.DEB.1.10.0807072127390.12950@asgard.lang.hm> <20080707214905.157be089@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707214905.157be089@infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-07-07 21:49:05, Arjan van de Ven wrote:
> On Mon, 7 Jul 2008 21:41:41 -0700 (PDT)
> david@lang.hm wrote:
> > umm, by merging the code a you reveal a lot of what they are
> > attempting to keep secret. what's to stop someone from reading the
> > code and writing the documentation?
> > 
> > that really should be someone at HP if you don't want to publish the 
> > exising documentation (since you are submitting the code)
> 
> I think you're being quite unreasonable here.
> In Linux we accept well written drivers even if there is no hardware
> docs. Sure we prefer them to be available, but is has never been a

This is not well-written driver. This is a layer that provides access
to hardware from userspace - AFAICT. But we are not told what hardware
does, nor how to control it.

Imagine a PC speaker "driver" that has two functions:

* write this to port 0x60

* write this to port 0x64

...and you don't get docs for the pc speaker. Only think that can use
your "driver" is proprietary binary. (Actually, in this case you are
not even told it is a pc speaker.)

I don't think that's acceptable...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
