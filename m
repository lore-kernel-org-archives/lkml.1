Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbXGTH3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbXGTH3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbXGTH3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:29:31 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:58216 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbXGTH3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:29:30 -0400
X-Greylist: delayed 1682 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 03:29:30 EDT
Date: Fri, 20 Jul 2007 09:01:06 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: drivers/base/core.c broken for non-CONFIG_HOTPLUG
Message-ID: <20070720070106.GH1678@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay,

With commit 60a96a59569bab85571d0089682109bd3324e896, you broke
drivers/base/core.c for systems which have not enabled CONFIG_HOTPLUG.

You add and use

	extern const char *kobject_actions[];

but the code in lib/kobject_uevent.c who actually brings in the code is
only compiled when CONFIG_HOTPLUG is enabled.

Please send a fix.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

