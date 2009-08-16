Return-Path: <linux-kernel-owner+w=401wt.eu-S1751210AbZHPQ2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbZHPQ2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 12:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbZHPQ2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 12:28:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38407 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZHPQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 12:28:01 -0400
Date: Sun, 16 Aug 2009 17:27:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Message-ID: <20090816162755.GA14971@sirena.org.uk>
References: <1249922635-31864-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249922635-31864-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090816132812.GO4302@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816132812.GO4302@infomag.iguana.be>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] [WATCHDOG] Add support for WM831x watchdog
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 03:28:12PM +0200, Wim Van Sebroeck wrote:

> > +#define WM831X_WDOG_PRIMACT_WIDTH                    2  /* WDOG_PRIMACT - [5:4] */

> These lines exceed 80 characters. Is there any reason why we can't reduce the spacing between the name and the value?

> Just let me know how we will proceed on my second question. I can then add this to the linux-2.6-watchdog-next tree.

The register definitions are automatically generated using the chip
design information using a tool which I'm not the only user for.  It
simplifies maintinance to keep the output code as-is since it allows
easier comparison with future devices with the same or similar IP in
them.  If anything were done I'd remove the comments.
