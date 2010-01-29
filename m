Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563Ab0A2OEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0A2OEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447Ab0A2OEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:04:13 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:48544 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755383Ab0A2OEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:04:13 -0500
Date: Fri, 29 Jan 2010 17:04:11 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Clean up wm97xx_battery warnings
Message-ID: <20100129140411.GB14935@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1264625135-4075-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201001291111.11133.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201001291111.11133.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 11:11:11AM +0100, Marek Vasut wrote:
> Dne St 27. ledna 2010 21:45:35 Mark Brown napsal(a):
> > Staticise work_lock (nothing outside the driver has any reason to
> > see it) and specify dev when requesting the charger IRQ (since that's
> > what we pass in when we free it).
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Hi, thanks.
> 
> Acked-by: Marek Vasut <marek.vasut@gmail.com>

Applied to battery-2.6 (for 2.6.34). Thanks!
