Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYEZMd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYEZMd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbYEZMZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:25:37 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:11996 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756479AbYEZMZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:25:35 -0400
Date: Mon, 26 May 2008 16:25:33 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mmc_spi: export probe and remove functions
Message-ID: <20080526122533.GA9595@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080523182754.GA26891@polina.dev.rtsoft.ru> <20080523182834.GA469@polina.dev.rtsoft.ru> <20080526141836.72db0623@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080526141836.72db0623@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 02:18:36PM +0200, Pierre Ossman wrote:
> On Fri, 23 May 2008 22:28:34 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > ...so we'll able to write bindings for the OpenFirmware without
> > messing with #ifdefs in the driver itself.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> This looks extremely wrong. Encapsulating probe functions isn't exactly
> in line with the device model and bound to confuse people.
> 
> Your patches doesn't give a complete picture of the OF side of things,
> but can't you solve this by having an init callback somewhere?

Easily, I think this is good (better) idea. Will do.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
