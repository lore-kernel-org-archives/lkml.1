Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbZGaLKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbZGaLKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 07:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZGaLKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 07:10:45 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34965 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZGaLKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <4A719811.4060904@csr.com>
References: <1248954848.5396.6.camel@localhost> <4A719811.4060904@csr.com>
From: Ohad Ben-Cohen <ohad@bencohen.org>
Date: Fri, 31 Jul 2009 14:10:24 +0300
Message-ID: <bd5b16740907310410q6860eba1m58e5cf2b771d157b@mail.gmail.com>
Subject: Re: [PATCH] sdio: add CD disable support
To: David Vrabel <david.vrabel@csr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>,
       Matt Fleming <matt@console-pimps.org>, ian@mnementh.co.uk,
       pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es,
       Adrian Hunter <adrian.hunter@nokia.com>, Madhusudhan <madhu.cr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thank you for your comments.

On Thu, Jul 30, 2009 at 3:54 PM, David Vrabel<david.vrabel@csr.com> wrote:
> Platforms may rely on the card's pull-up and not fit/configure an
> external one.  There may need to be a way for host controller drivers to
>  say this and prevent the disabling of the card's DAT3 pull-up.

Currently the only way to really disable the CD using this patch is by
setting the disable_cd bit on for a specific controller. We are doing so
for a specific controller to which an embedded sdio device is wired,
on certain boards. This is done using the embedded_sdio's .cccr field,
which is used instead of reading the card's cccr.
So as you correctly noted, card has no say here.

> The first sentence of this comment doesn't make sense.

Fixed;

I'll follow-up with a correction of the patch and will appreciate your review.

Thanks,
Ohad.
