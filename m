Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZGaKyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZGaKyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZGaKyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:54:36 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:65398 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZGaKyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:54:36 -0400
Date: Fri, 31 Jul 2009 11:54:07 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       ian@mnementh.co.uk, HaraldWelte@viatech.com, JosephChan@via.com.tw,
       adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-ID: <20090731105407.GA31900@console-pimps.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu> <20090722151744.fffd7bf5.akpm@linux-foundation.org> <20090728222334.0c543c47@mjolnir.ossman.eu> <20090731122623.254fd0f1@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090731122623.254fd0f1@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 12:26:23PM +0200, Pierre Ossman wrote:
> 
> [PATCH 0/32] mmc and omap_hsmmc patches
> http://marc.info/?t=124722953900010&r=1&w=2
> 
> I haven't looked through these at all. The ones affecting the core
> probably need some thorough reviews.
> 
> I did notice the patch to say which cards a controller supports though,
> and I'm very sceptical about that one. The scanning process should work
> anyway, and the performance impact should be negligible as it is only
> on init. So that patch only adds complexity and confusion IMO.
> 

How much complexity does it really add? Surely it's better to give the
host controller driver writers the ability to not entertain supporting
some cards if they cannot be used? If they want to avoid the scanning
process for certain cards, why not let them?


