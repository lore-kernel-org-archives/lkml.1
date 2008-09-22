Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYIVUI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYIVUI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYIVUIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:08:49 -0400
Received: from ppp-111-105.adsl.restena.lu ([158.64.111.105]:49052 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbYIVUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:08:48 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 16:08:48 EDT
Date: Mon, 22 Sep 2008 22:00:54 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Michal Januszewski <spock@gentoo.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: don't allow to set a video
 mode via vga= if FB doesn't support it
Message-ID: <20080922220054.4e74c099@neptune.home>
In-Reply-To: <20080922214747.c8bc57eb.krzysztof.h1@poczta.fm>
References: <20080921210219.GC21215@spock.one.pl>
	<20080922214747.c8bc57eb.krzysztof.h1@poczta.fm>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>
> Currently, it is possible to set a VESA graphics mode at boot time
> via the vga= parameter even when no framebuffer driver supporting
> this is configured.  This could lead to the system booting with a
> black screen, without a usable console.
> 
This looks pretty much the same as what I requested some time ago:

http://bugzilla.kernel.org/show_bug.cgi?id=8062

Would need to check -mm archives for the actual patch.

Don't remember why it did not make it to mainline...

Bruno
