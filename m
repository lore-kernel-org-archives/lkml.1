Return-Path: <linux-kernel-owner+w=401wt.eu-S2993032AbXDDS7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993032AbXDDS7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993035AbXDDS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:59:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55294 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993033AbXDDS7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:59:34 -0400
Date: Wed, 4 Apr 2007 12:00:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Message-Id: <20070404120025.4c5548dc.randy.dunlap@oracle.com>
In-Reply-To: <11757100281957-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757099743984-git-send-email-tony@atomide.com>
	<1175709977545-git-send-email-tony@atomide.com>
	<1175709988265-git-send-email-tony@atomide.com>
	<11757099942493-git-send-email-tony@atomide.com>
	<11757100011056-git-send-email-tony@atomide.com>
	<1175710003925-git-send-email-tony@atomide.com>
	<11757100063945-git-send-email-tony@atomide.com>
	<11757100092910-git-send-email-tony@atomide.com>
	<11757100112473-git-send-email-tony@atomide.com>
	<11757100143517-git-send-email-tony@atomide.com>
	<11757100163760-git-send-email-tony@atomide.com>
	<11757100181189-git-send-email-tony@atomide.com>
	<11757100214151-git-send-email-tony@atomide.com>
	<11757100242980-git-send-email-tony@atomide.com>
	<1175710026446-git-send-email-tony@atomide.com>
	<11757100281957-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:05:04 -0400 Tony Lindgren wrote:

> +static int __init fpga_init(void)
> +{
> +	if (machine_is_omap_h4()
> +			|| machine_is_omap_h3()
> +			|| machine_is_omap_h2()
> +			|| machine_is_omap_perseus2()
> +			)

Perhaps there is nothing in CodingStyle for if () continuation
lines.  Looks like it is needed.  This is ETOOMUCHINDENTATION by
at least one tab.  Should be more like:

+	if (machine_is_omap_h4()
+	    || machine_is_omap_h3()
+	    || machine_is_omap_h2()
+	    || machine_is_omap_perseus2())


(without getting into where the "||" should be placed).

> +		return platform_driver_register(&led_driver);
> +	return 0;
> +}
> +fs_initcall(fpga_init);

fs, eh?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
