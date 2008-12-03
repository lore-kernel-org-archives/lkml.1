Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYLCSOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYLCSOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYLCSOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:14:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48266 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbYLCSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:14:33 -0500
Date: Wed, 3 Dec 2008 19:16:05 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Chris Friesen <cfriesen@nortel.com>,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081203181605.GA22852@elf.ucw.cz>
References: <20081202152618.GA1646@ucw.cz> <20081202163720.GB18162@mit.edu> <49356EF2.7060806@nortel.com> <20081202205558.GD20858@mit.edu> <20081202224403.GA8277@elf.ucw.cz> <20081203050709.GL20858@mit.edu> <20081203084639.GB1944@ucw.cz> <Pine.LNX.4.64.0812031637050.5406@artax.karlin.mff.cuni.cz> <20081203155449.6ea98768@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0812031754040.25439@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812031754040.25439@artax.karlin.mff.cuni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > CRC errors, lost IRQs and the like are retried by the midlayer and
> > drivers and the error handling strategies will also try things like
> > reducing link speeds on repeated CRC errors.
> 
> I meant for example loose cable or so --- does it make sense to retry 
> indefinitely (until the admin plugs the cable or unmounts the filesystem) 
> or return error to the filesystem after few retries?

It is quite non-trivial to detect if it is "disk plugged back in"
vs. "faulty disk unplugged, new one plugged in"... so I suppose
automatic retry after failure of connection to disk is quite hard to
get right.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
