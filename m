Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXLHUov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXLHUov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXLHUoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:44:39 -0500
Received: from 1wt.eu ([62.212.114.60]:2602 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbXLHUoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:44:38 -0500
Date: Sat, 8 Dec 2007 21:42:39 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matt Mackall <mpm@selenic.com>, Theodore Tso <tytso@mit.edu>,
       Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
Subject: Re: entropy gathering (was Re: Why does reading from /dev/urandom deplete entropy so much?)
Message-ID: <20071208204239.GG15227@1wt.eu>
References: <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org> <475AF241.5000809@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AF241.5000809@garzik.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 02:36:33PM -0500, Jeff Garzik wrote:
> 
> As an aside...
> 
> Speaking as the maintainer rng-tools, which is the home of the hardware 
> RNG entropy gathering daemon...
> 
> I wish somebody (not me) would take rngd and several other projects, and 
> combine them into a single actively maintained "entropy gathering" package.
> 
> IMO entropy gathering has been a long-standing need for headless network 
> servers (and now virtual machines).
> 
> In addition to rngd for hardware RNGs, I've been daemons out there that 
> gather from audio and video sources (generally open wires/channels with 
> nothing plugged in), thermal sources, etc.  There is a lot of entropy 
> that could be gathered via userland, if you think creatively.

I remember having installed openssh on an AIX machines years ago, and
being amazed by the number of sources it collected entropy from. Simple
commands such as "ifconfig -a", "netstat -i" and "du -a", "ps -ef", "w"
provided a lot of entropy.

Regards,
Willy

