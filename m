Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387Ab0AKKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0AKKvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028Ab0AKKvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:51:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60305 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0AKKvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:51:31 -0500
Date: Mon, 11 Jan 2010 10:51:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20100111105126.GD3440@sirena.org.uk>
References: <20100111160232.e37e5393.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111160232.e37e5393.sfr@canb.auug.org.au>
X-Cookie: What is the sound of one hand clapping?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 04:02:32PM +1100, Stephen Rothwell wrote:
> Hi Sam,

> Today's linux-next build (x86_64_allmodconfig, gcc 4.4.0, binutils
> 2.19.1) failed like this:

> ERROR: "max8925_set_bits" [drivers/video/backlight/max8925_bl.ko] undefined!
> ERROR: "max8925_reg_write" [drivers/video/backlight/max8925_bl.ko] undefined!
> ERROR: "max8925_reg_read" [drivers/video/backlight/max8925_bl.ko] undefined!
> ERROR: "max8925_set_bits" [drivers/regulator/max8925.ko] undefined!
> ERROR: "max8925_reg_read" [drivers/regulator/max8925.ko] undefined!

> I am not sure what caused this, so I have used the version of the mfd
> tree from next-20100108 for today.

CCing in Haojian who did the driver.  I've not looked but I'd guess that
the issue is missing EXPORT_SYMBOL{,_GPL}s on the symbols above.
