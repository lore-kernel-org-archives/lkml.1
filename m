Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZHPPpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZHPPpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZHPPpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:45:17 -0400
Received: from THUNK.ORG ([69.25.196.29]:53360 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZHPPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:45:15 -0400
Date: Sun, 16 Aug 2009 11:44:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>, Mark Lord <liml@rtr.ca>,
       Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
	slot is freed)
Message-ID: <20090816154430.GE17958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	James Bottomley <James.Bottomley@suse.de>, Mark Lord <liml@rtr.ca>,
	Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
	Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Matthew Wilcox <willy@linux.intel.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
References: <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com> <4A85E0DC.9040101@rtr.ca> <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com> <20090814234539.GE27148@parisc-linux.org> <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com> <1250341176.4159.2.camel@mulgrave.site> <4A86B69C.7090001@rtr.ca> <1250344518.4159.4.camel@mulgrave.site> <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk> <20090816083434.2ce69859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816083434.2ce69859@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 08:34:34AM -0700, Arjan van de Ven wrote:
> trim is mostly for ssd's though, and those tend to not have the "goes
> for a hike" behavior as much......

Mark Lord has claimed that the currently shipping SSD's take "hundreds
of milliseconds" for a TRIM, command.  Compared to the usual latency
of an SSD, that could very well be considered "takes a coffee break"
behaviour; maybe not "goes for a hike", but enough that you wouldn't
want to be doing one all the time.

The story that I've heard which worries me is that those of us which
were silly enough to spend $400 and $800 dollars on the first
generation X25-M drives may never get TRIM support, and that TRIM
support might only be offered on the second generation X25-M drives.
I certainly _hope_ that is not true, but in any case, I don't have any
TRIM capable drives at the moment, so it's not something which I'm set
up to test....

					- Ted
