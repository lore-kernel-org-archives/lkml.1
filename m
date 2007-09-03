Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbXICIN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbXICIN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXICINs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:13:48 -0400
Received: from smtp2e.orange.fr ([80.12.242.112]:57546 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbXICINr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:13:47 -0400
X-ME-UUID: 20070903081346767.BB4C27000094@mwinf2e08.orange.fr
Subject: [OT] Re: very very strange simultaneous RAID resync on sep 2,
	01:06 CEST (+2)
From: Xavier Bestel <xavier.bestel@free.fr>
To: Patrick Mau <mau@oscar.ping.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070903080641.GA2074@oscar.prima.de>
References: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
	 <20070903080641.GA2074@oscar.prima.de>
Content-Type: text/plain
Date: Mon, 03 Sep 2007 10:13:43 +0200
Message-Id: <1188807223.1131.492.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 10:06 +0200, Patrick Mau wrote:
> My debian installation has a system cronjob that will perform a resync
> every first Sunday morning at 1:06 AM:
> 
> [root@oscar] cat /etc/cron.d/mdadm
> ...
> 6 1 * * 0 root [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -
> le 7 ] && /usr/share/mdadm/checkarray --cron --all --quiet
> 
> I did not read the manpage, but my guess is that 'quiet' will suppress
> the mail notification.

Yes, that was it, checkarray leaves traces in the syslog.
Now I'm really ashamed I jumped on my mailer before using what's left of
my braincells. Could I take it back please ?

Thanks,

	Xav


