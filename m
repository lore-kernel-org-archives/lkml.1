Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYGHKs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYGHKs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 06:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYGHKsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 06:48:19 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:28976 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYGHKsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:48:19 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-4.tower-37.messagelabs.com!1215514097!3235264!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 8 Jul 2008 12:48:13 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UIO: Change driver name of uio_pdrv
Message-ID: <20080708104813.GA22195@digi.com>
References: <20080707222300.GA5149@local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080707222300.GA5149@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 08 Jul 2008 10:48:14.0558 (UTC) FILETIME=[1F800FE0:01C8E0E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Hans J. Koch wrote:
> I'm just about to use the generic UIO platform device driver in a
> project. I noticed the driver registers itself simply as "uio". We
> should choose a more unique name here. The oneliner below goes on top of
> the other UIO patches you've got in your queue right now. This is not in
> mainline yet.
I don't care much, but IMHO "uio" is fine, because the name has a
context (i.e. it's the name of a platform device) and so adding "_pdrv"
doesn't yield a more clear result.

I don't claim to know all or even many platform drivers, the ones I
currently use (and that are in mainline, too) are:

	gpio-keys
	i2c-gpio
	leds-gpio
	physmap-flash
	serial8250

and for all of these I consider it right not to have a "pdrv" suffix.

> The generic UIO platform device driver should be given a unique driver ID and
> not just "uio". This is especially important since Magnus Damm announced a
> similar driver named uio_pdrv_genirq. We should get the names right before
> this hits mainline.
So using uio_genirq here would be the logical consequence.

But as I said, I don't care much and both options are fine for me.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
