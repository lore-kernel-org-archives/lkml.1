Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZGBO0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZGBO0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZGBO0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:26:46 -0400
Received: from ru.mvista.com ([213.79.90.228]:27379 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753054AbZGBO0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:26:46 -0400
Date: Thu, 2 Jul 2009 18:26:44 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
 and use it for olpc driver
Message-ID: <20090702142644.GA1281@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090630021730.44f86185@mycelium.queued.net>
 <20090630231450.GD12076@oksana.dev.rtsoft.ru>
 <20090702094518.3d44eca3@mycelium.queued.net>
 <20090702140653.GA3558@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090702140653.GA3558@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 03:06:53PM +0100, Mark Brown wrote:
> On Thu, Jul 02, 2009 at 09:45:18AM -0400, Andres Salomon wrote:
> 
> > This adds a new sysfs file called 'charge_type' which displays the type of
> > charging (unknown, n/a, trickle charge, or fast charging).  This allows
> > things like battery diagnostics to determine what the battery/EC is doing
> > without resorting to changing the 'status' sysfs output.
> > 
> > Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Much thanks to both of you.

This is now applied to battery-2.6.git (for -next).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
