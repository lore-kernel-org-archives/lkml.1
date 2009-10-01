Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZJAPD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZJAPD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZJAPD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:03:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58853 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752686AbZJAPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:03:28 -0400
Date: Thu, 1 Oct 2009 16:03:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] power_supply: Factor out WM831x backup battery
 charger
Message-ID: <20091001150330.GA16177@rakim.wolfsonmicro.main>
References: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20091001145500.GA21973@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001145500.GA21973@oksana.dev.rtsoft.ru>
X-Cookie: Truckers welcome.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 06:55:00PM +0400, Anton Vorontsov wrote:

> Looks good. Should I apply it, or it depends on 1/4 and 2/4?

There should be no build time dependency so you should be able to apply
it.  It'd mean that the WM8320 won't get the backup battery charger
instantiating until it's merged with the power tree but that's not a
terribly big deal and it would avoid the possibility of any merge issues
from a colliding Makefile/Kconfig change in drivers/power.

Samuel, do you have any preferences?
