Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbXLHSHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbXLHSHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXLHSHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:07:04 -0500
Received: from thunk.org ([69.25.196.29]:42710 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXLHSHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:07:01 -0500
Date: Sat, 8 Dec 2007 13:05:57 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Jon Masters <jonathan@jonmasters.org>, Mike McGrath <mmcgrath@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071208180557.GL17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Mike McGrath <mmcgrath@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
	Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <20071208174343.GK19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208174343.GK19691@waste.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 11:43:43AM -0600, Matt Mackall wrote:
> > Huh?  What's the concern?  All you are submitting is a list of
> > hardware devices in your system.  That's hardly anything sensitive....
> 
> Using MAC addresses -does- de-anonymize things though and presumably
> anonymous collection is a stated goal.

True, but for many machines, the MAC address is enough for someone
knowledgeable to (at least) determine what the manufacturer of your
machine is, and in many cases, the model number of your laptop (since
MAC addresses are assigned sequentially) and thus people can have a
very good idea of the contents of your PCI tree ---- if for some
reason anyone would even care, of course!

					- Ted
