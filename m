Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXLHTh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXLHTh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXLHThW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:37:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37754 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbXLHThV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:37:21 -0500
Message-ID: <475AF241.5000809@garzik.org>
Date: Sat, 08 Dec 2007 14:36:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>, Theodore Tso <tytso@mit.edu>
CC: Mike McGrath <mmcgrath@redhat.com>, Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
Subject: entropy gathering (was Re: Why does reading from /dev/urandom deplete
 entropy so much?)
References: <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org>
In-Reply-To: <20071208181525.GL19691@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As an aside...

Speaking as the maintainer rng-tools, which is the home of the hardware 
RNG entropy gathering daemon...

I wish somebody (not me) would take rngd and several other projects, and 
combine them into a single actively maintained "entropy gathering" package.

IMO entropy gathering has been a long-standing need for headless network 
servers (and now virtual machines).

In addition to rngd for hardware RNGs, I've been daemons out there that 
gather from audio and video sources (generally open wires/channels with 
nothing plugged in), thermal sources, etc.  There is a lot of entropy 
that could be gathered via userland, if you think creatively.

	Jeff



