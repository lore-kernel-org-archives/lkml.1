Return-Path: <linux-kernel-owner+w=401wt.eu-S1751056AbXCBVkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbXCBVkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbXCBVkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:40:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54966
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbXCBVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:40:06 -0500
Date: Fri, 02 Mar 2007 13:40:05 -0800 (PST)
Message-Id: <20070302.134005.55727374.davem@davemloft.net>
To: romosan@sycorax.lbl.gov
Cc: hmh@hmh.eng.br, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, rpurdie@rpsys.net
Subject: Re: 2.6.21-rc2 radeon backlight
From: David Miller <davem@davemloft.net>
In-Reply-To: <87mz2v5oj0.fsf@sycorax.lbl.gov>
References: <20070302.123514.35465791.davem@davemloft.net>
	<20070302210157.GA11786@khazad-dum.debian.net>
	<87mz2v5oj0.fsf@sycorax.lbl.gov>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Romosan <romosan@sycorax.lbl.gov>
Date: Fri, 02 Mar 2007 13:22:27 -0800

> if i don't enable the radeon backlight support the backlight works and
> i can turn it on and off using radeontool. if i enable the radeon
> backlight support the screen stays dark (although i can log on my
> laptop remotely). if i try to use radeontool to turn the backlight on
> nothing happens. so, at least on the thinkpad, the radeon backlight
> support disables some other kind of backlight support that works
> otherwise.

Right, that's the crux of the problem.

The Radeon backlight support conflicts somehow with the
way the ACPI code programs the same hardware, and until
we figure out exactly what's going on, this is a regression.
