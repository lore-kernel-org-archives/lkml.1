Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZHNQtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZHNQtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 12:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZHNQtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 12:49:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56571 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751768AbZHNQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 12:49:52 -0400
Date: Fri, 14 Aug 2009 17:49:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 3/5] power_supply: Add driver for the PMU on WM831x
 PMICs
Message-ID: <20090814164952.GB21021@rakim.wolfsonmicro.main>
References: <1249922635-31864-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249922635-31864-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090814020008.GA5238@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814020008.GA5238@oksana.dev.rtsoft.ru>
X-Cookie: Heisenberg might have been here.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 06:00:08AM +0400, Anton Vorontsov wrote:

> I don't see the rest of the series, so I assume this patch
> depends on some other patches. So, feel free to merge it through
> your tree.

> Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Actually the only merge dependency is on the power tree - the Kconfig
dependency on MFD_WM831X will prevent it being built until the MFD
dependencies are but the driver uses the new charge_type property from
the power tree.
