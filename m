Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbXLHRdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbXLHRdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXLHRdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:33:14 -0500
Received: from thunk.org ([69.25.196.29]:53118 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbXLHRdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:33:13 -0500
Date: Sat, 8 Dec 2007 12:32:04 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Mike McGrath <mmcgrath@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071208173204.GI17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jon Masters <jonathan@jonmasters.org>,
	Mike McGrath <mmcgrath@redhat.com>, Matt Mackall <mpm@selenic.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
	Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197099477.20786.149.camel@perihelion>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 02:37:57AM -0500, Jon Masters wrote:
> > BTW, You may be better off using "uuidgen -t" to generate the UUID in
> > the smolt RPM, since that will use 12 bits of randomness from
> > /dev/random, plus the MAC, address and timestamp.  So even if there is
> > zero randomness in /dev/random, and the time is January 1, 1970, at
> > least the MAC will contribute some uniqueness to the UUID.
> 
> I haven't checked how uuidgen uses the MAC, but I would suggest that
> that is not something Fedora should jump at doing - although it would
> help ensure unique UUIDs, it also contributes to the tinfoil hat
> responses that usually come up with things like smolt.

Huh?  What's the concern?  All you are submitting is a list of
hardware devices in your system.  That's hardly anything sensitive....

	 	    	 	  	 - Ted
