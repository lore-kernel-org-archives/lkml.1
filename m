Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZIANXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZIANXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZIANXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:23:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59103 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbZIANXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:23:38 -0400
Date: Tue, 1 Sep 2009 15:23:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: linux-parport@lists.infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] parport: Add character LCD driver for da850/omap-l138
Message-ID: <20090901132330.GB1569@ucw.cz>
References: <1251840159-22313-1-git-send-email-sudhakar.raj@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251840159-22313-1-git-send-email-sudhakar.raj@ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On TI DA850/OMAP-L138 EVM, HD44780 (24x2) LCD panel is
> being used, interfaced through the SoC specific LCD
> interface[1].
> 
> Driver from drivers/staging/panel/panel.c works for this
> LCD panel but that driver expects the LCD panel to be
> interfaced through a parallel port.
> 
> This patch implements a dummy parallel port driver which
> interfaces to the panel driver in staging area through the
> LCD interface available on SoC.

This is a nasty hack, right? Just fixup panel.c to work with your
interface, too?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
