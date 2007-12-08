Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbXLHXs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbXLHXs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 18:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXLHXsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 18:48:20 -0500
Received: from THUNK.ORG ([69.25.196.29]:37317 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbXLHXsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 18:48:19 -0500
Date: Sat, 8 Dec 2007 18:47:21 -0500
From: Theodore Tso <tytso@mit.edu>
To: Willy Tarreau <w@1wt.eu>
Cc: Jeff Garzik <jeff@garzik.org>, Matt Mackall <mpm@selenic.com>,
       Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
Subject: Re: entropy gathering (was Re: Why does reading from /dev/urandom
	deplete entropy so much?)
Message-ID: <20071208234721.GR17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
	Jeff Garzik <jeff@garzik.org>, Matt Mackall <mpm@selenic.com>,
	Mike McGrath <mmcgrath@redhat.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
	Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org, hmh@debian.org
References: <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org> <475AF241.5000809@garzik.org> <20071208204239.GG15227@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208204239.GG15227@1wt.eu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 09:42:39PM +0100, Willy Tarreau wrote:
> I remember having installed openssh on an AIX machines years ago, and
> being amazed by the number of sources it collected entropy from. Simple
> commands such as "ifconfig -a", "netstat -i" and "du -a", "ps -ef", "w"
> provided a lot of entropy.

Well.... not as many bits of entropy as you might think.  But every
little bit helps, especially if some of it is not available to
adversary.

							- Ted
