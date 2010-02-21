Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0BUXhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 18:37:43 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:47172 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0BUXhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 18:37:42 -0500
Date: Mon, 22 Feb 2010 00:37:36 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: Re: [Bug #15039] leds_alix2: can't allocate I/O for GPIO
Message-ID: <20100221233736.GI28972@buzzloop.caiaq.de>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
 <ClJsQB_ZlxO.A.wdH.7fagLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ClJsQB_ZlxO.A.wdH.7fagLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Sun, Feb 21, 2010 at 10:30:13PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15039
> Subject		: leds_alix2: can't allocate I/O for GPIO
> Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> Date		: 2010-01-07 10:26 (46 days old)
> References	: http://marc.info/?l=linux-kernel&m=126286001106257&w=4
> Handled-By	: Daniel Mack <daniel@caiaq.de>
> Patch		: http://patchwork.kernel.org/patch/72006/
> 

This regression is fixedi (or better worked around) in your git by the
commit "leds: ALIX2: Add dependency to !GPIO_CS5335" (38b52483) but it
seems this isn't merged yet. Any plans to get this in for -rc8?

Thanks,
Daniel

