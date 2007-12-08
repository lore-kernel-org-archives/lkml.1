Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbXLHSZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbXLHSZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXLHSZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:25:34 -0500
Received: from thunk.org ([69.25.196.29]:38853 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbXLHSZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:25:33 -0500
Date: Sat, 8 Dec 2007 13:24:31 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Mike McGrath <mmcgrath@redhat.com>, Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071208182431.GN17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>, Mike McGrath <mmcgrath@redhat.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
	Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208181525.GL19691@waste.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 12:15:25PM -0600, Matt Mackall wrote:
> 
> It might be better for us to just improve the pool initialization.
> That'll improve the out of the box experience for everyone.
> 

Yeah, I agree.  Although keep in mind, doing things like mixing in MAC
address and DMI information (which we can either do in the kernel or
by trying to get all of the distro's to add that into their
/etc/init.d/random script --- all several hundred or thousand distro's
in the world :-), will help improve things like UUID uniqueness, it
doesn't necessarily guarantee /dev/urandom and UUID
*unpredictability*.  In order to do that we really do need to improve
the amount of hardware entropy we can mix into the system.  This is a
hard problem, but as more people are relying on these facilities, it's
something we need to think about quite a bit more!

	     	     	   	       - Ted
