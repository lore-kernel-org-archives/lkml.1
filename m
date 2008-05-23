Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYEWPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYEWPmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYEWPmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:42:10 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2489 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752589AbYEWPmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:42:07 -0400
Date: Fri, 23 May 2008 19:42:04 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card
	detect line
Message-ID: <20080523154204.GA19803@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080516165057.GC24196@polina.dev.rtsoft.ru> <20080517133633.5aa26938@mjolnir.drzeus.cx> <20080521184713.GA30284@polina.dev.rtsoft.ru> <20080521212831.523f344b@mjolnir.drzeus.cx> <20080522181713.GA26918@polina.dev.rtsoft.ru> <20080522213432.4a50629b@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080522213432.4a50629b@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:34:32PM +0200, Pierre Ossman wrote:
[...]
> > Ok. How about this version?
> > 
> 
> Perfect. Unless there is some way you can pass flags in platform data?
> Using the lack of an init() to determine the need for polling is a bit
> circumstantial.

Aha, that's an idea, thanks. Implemented in the updated patches.

p.s.
I think, in case of capabilities, it's users' responsibility to not
issue bogus flags, so mmc_spi doesn't mask anything, it just passes
platform's caps. This also avoids drivers update when (if) new caps
will be implemented.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
