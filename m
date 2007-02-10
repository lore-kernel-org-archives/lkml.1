Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbXBJPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbXBJPWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 10:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbXBJPWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 10:22:33 -0500
Received: from iona.labri.fr ([147.210.8.143]:41393 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590AbXBJPWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 10:22:32 -0500
Date: Sat, 10 Feb 2007 16:22:26 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Levitsky Maxim <maximlevitsky@yahoo.com>, linux-kernel@vger.kernel.org,
       tori@unhappy.mine.nu, netdev@vger.kernel.org,
       sebastien.hinderer@loria.fr
Subject: Re: [PATCH] [NETDEV] [000]  dmfe : fix bugs and add features
Message-ID: <20070210152226.GA3482@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jeff Garzik <jeff@garzik.org>,
	Levitsky Maxim <maximlevitsky@yahoo.com>,
	linux-kernel@vger.kernel.org, tori@unhappy.mine.nu,
	netdev@vger.kernel.org, sebastien.hinderer@loria.fr
References: <96797.60132.qm@web38511.mail.mud.yahoo.com> <45CCE46E.9010902@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45CCE46E.9010902@garzik.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jeff Garzik, le Fri 09 Feb 2007 16:15:26 -0500, a écrit :
> Levitsky Maxim wrote:
> >Before some time I decided to fix suspend/resume on my Davicom
> >network card.  During development I also fixed couple of bugs and
> >added support for link detection and WOL Note : 2.6.20 already has
> >support for link detection , but it is broken when card has external
> >PHY, like mine.
> >
> >So here it goes:
> >
> >[PATCH] [NET] [001] dmfe : trivial/spelling fixes
> >[PATCH] [NET] [002] dmfe : Fix possible oops
> >[PATCH] [NET] [003] dmfe : fix link detection
> >[PATCH] [NET] [004] dmfe : Add suspend/resume support
> >[PATCH] [NET] [005] dmfe : Add support for wake-on-lan
> 
> >Commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 (drivers/net/tulip/dmfe: 
> >support basic carrier detection) breaks networking on my Davicom DM9009. 
> >ethtool always reports there is no link.  tcpdump shows incoming 
> >packets, but TX is disabled.  Reverting the above patch fixes the 
> >problem.
> 
> What about the above report?
> 
> I would rather fix this first, before applying more patches on top of a 
> problematic patch...

My patch wasn't implementing anything actually: it was just making the
existing-since-long link detection code available in ethtools.

Samuel
