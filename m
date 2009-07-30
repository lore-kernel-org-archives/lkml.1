Return-Path: <linux-kernel-owner+w=401wt.eu-S1751261AbZG3MqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbZG3MqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbZG3MqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:46:12 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:50235 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZG3MqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:46:11 -0400
Date: Thu, 30 Jul 2009 13:45:43 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ohad Ben-Cohen <ohad@bencohen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>, ian@mnementh.co.uk,
       pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es,
       Adrian Hunter <adrian.hunter@nokia.com>, Madhusudhan <madhu.cr@ti.com>
Subject: Re: [PATCH] sdio: add CD disable support
Message-ID: <20090730124543.GF3058@console-pimps.org>
References: <1248954848.5396.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248954848.5396.6.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 02:54:08PM +0300, Ohad Ben-Cohen wrote:
> From: Ohad Ben-Cohen <ohad@wizery.com>
> 
> To save power, the pull-up resistor on CD/DAT[3] (pin 1)
> of the card can be disconnected. This is desired, e.g.,
> with embedded SDIO devices which do not rely on this pin
> for card detection.
> 
> Signed-off-by: Ohad Ben-Cohen  <ohad@wizery.com>
> ---
>  drivers/mmc/core/sdio.c  |   32 ++++++++++++++++++++++++++++++++
>  include/linux/mmc/card.h |    3 ++-
>  2 files changed, 34 insertions(+), 1 deletions(-)
> 

Do you have a follow-up patch to make use of this new functionality? I
can't see anywhere where disable_cd is set.


