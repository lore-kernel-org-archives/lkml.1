Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYFPNXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYFPNXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYFPNXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:23:34 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14903 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756620AbYFPNXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:23:33 -0400
Date: Mon, 16 Jun 2008 17:23:30 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jochen Friedrich <jochen@scram.de>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC v3] OF: OpenFirmware bindings for the mmc_spi
	driver
Message-ID: <20080616132330.GA7468@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080605161624.GA517@polina.dev.rtsoft.ru> <20080614175723.209e93dc@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080614175723.209e93dc@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 05:57:23PM +0200, Pierre Ossman wrote:
> On Thu, 5 Jun 2008 20:16:24 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > Here is v3. I'm out of ideas if you won't like it. :-)
> > 
> > v3:
> > - Now these bindings are using bus notifiers chain, thus we adhere to the
> >   spi bus.
> > 
> 
> Now this was nice and clean. I take it Grant doesn't like this version
> though. What's the downside of it?

To me the main downside of it is inability to make this modular. :-/

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
