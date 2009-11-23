Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZKWOm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZKWOm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZKWOm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:42:28 -0500
Received: from mga10.intel.com ([192.55.52.92]:9992 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbZKWOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:42:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,272,1257148800"; 
   d="scan'208";a="749602188"
Date: Mon, 23 Nov 2009 15:44:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20091123144413.GD3616@sortiz.org>
References: <20091123144103.73b4d64c.sfr@canb.auug.org.au>
 <20091123150346.e3948feb.sfr@canb.auug.org.au>
 <20091123122903.GB3616@sortiz.org>
 <20091123131113.GE24326@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123131113.GE24326@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 01:11:13PM +0000, Mark Brown wrote:
> On Mon, Nov 23, 2009 at 01:29:04PM +0100, Samuel Ortiz wrote:
> 
> > True. Mark, I think we should get those symbols exported, unless you have a
> > better idea ? Having wm831x as a boolean choice from Kconfig doesnt sound too
> > god to me.
> 
> I don't see getting them exported flying, especially not in the
> timeframe we've got for the merge window.  Keeping them non-exported has
> been a deliberate decision on the part of the genirq maintainers. 
Out of curiosity, what's the reasoning behind thatdecision ?

> I'll send a patch making it built in.
Thanks, patch applied.

Cheers,
Samuel.


> Given the typical applications for these parts building the driver in
> isn't the end of the world - there's a reasonable chance it'll be forced
> built in for other reasons due to device-specific configuration.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
