Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbXLHT40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbXLHT40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXLHT4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:56:19 -0500
Received: from waste.org ([66.93.16.53]:39467 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbXLHT4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:56:18 -0500
Date: Sat, 8 Dec 2007 13:53:42 -0600
From: Matt Mackall <mpm@selenic.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Theodore Tso <tytso@mit.edu>, Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
Subject: Re: entropy gathering (was Re: Why does reading from /dev/urandom deplete entropy so much?)
Message-ID: <20071208195342.GO19691@waste.org>
References: <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org> <475AF241.5000809@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AF241.5000809@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
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

I think we should re-evaluate having an internal path from the hwrngs
to /dev/[u]random, which will reduce the need for userspace config
that can go wrong.

-- 
Mathematics is the supreme nostalgia of our time.
