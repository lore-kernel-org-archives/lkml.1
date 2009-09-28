Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbZI1ReM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbZI1ReM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZI1ReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:34:11 -0400
Received: from ru.mvista.com ([213.79.90.228]:4776 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751811AbZI1ReL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:34:11 -0400
Date: Mon, 28 Sep 2009 21:34:13 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] powerpc/cpm: Remove SPI defines and spi structs
Message-ID: <20090928173413.GA8795@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
 <20090818220410.GA25090@oksana.dev.rtsoft.ru>
 <C37BD1BB-7F53-4CC7-ABB0-BBBDDAC5C052@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C37BD1BB-7F53-4CC7-ABB0-BBBDDAC5C052@kernel.crashing.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 12:45:34AM -0500, Kumar Gala wrote:
> 
> On Aug 18, 2009, at 5:04 PM, Anton Vorontsov wrote:
> 
> >When cpm2.h included into spi_mpc8xxx driver, the SPI defines
> >in the header conflict with defines in the driver.
> >
> >We don't need them in the header file, so remove them. Plus
> >remove "struct spi", we'll use a better version in the driver.
> >
> >Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> >---
> >arch/powerpc/include/asm/cpm1.h |   45
> >---------------------------------------
> >arch/powerpc/include/asm/cpm2.h |   39
> >---------------------------------
> >2 files changed, 0 insertions(+), 84 deletions(-)
> 
> applied to next

I can't find it in 2.6.32-rc1. Somehow it got lost from your next tree?
The same for all powerpc patches from this series.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
