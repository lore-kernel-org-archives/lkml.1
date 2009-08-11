Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZHKMDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZHKMDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZHKMDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:03:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42059 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZHKMDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:03:17 -0400
Date: Tue, 11 Aug 2009 10:56:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Timur Tabi <timur@freescale.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] soc: fix I2C build errors
Message-ID: <20090811095636.GE24947@sirena.org.uk>
References: <20090810203508.f3258129.sfr@canb.auug.org.au> <20090810160439.72e417de.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810160439.72e417de.randy.dunlap@oracle.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 04:04:39PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>

> Fix soc build errors when I2C is built as a loadable module:

> (.text+0x5d26b): undefined reference to `i2c_master_send'
> soc-cache.c:(.text+0x5d32d): undefined reference to `i2c_transfer'

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Timur Tabi <timur@freescale.com>

I've applied this.

It'd be helpful if in future you could try to CC the relevant
maintainers on patches.  Here you've CCed Timur (who had nothing to do
with any of this code) but none of the ASoC or ALSA maintainers. 
