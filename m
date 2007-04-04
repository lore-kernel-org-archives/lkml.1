Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbXDDUI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbXDDUI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXDDUI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:08:26 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:34987 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbXDDUIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:08:25 -0400
Date: Wed, 4 Apr 2007 22:06:34 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
In-Reply-To: <20070404120025.4c5548dc.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0704042205040.22282@yvahk01.tjqt.qr>
References: <11757099691323-git-send-email-tony@atomide.com>
 <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com>
 <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com>
 <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com>
 <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com>
 <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com>
 <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com>
 <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com>
 <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com>
 <20070404120025.4c5548dc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 4 2007 12:00, Randy Dunlap wrote:
>
>> +static int __init fpga_init(void)
>> +{
>> +	if (machine_is_omap_h4()
>> +			|| machine_is_omap_h3()
>> +			|| machine_is_omap_h2()
>> +			|| machine_is_omap_perseus2()
>> +			)
>
>Perhaps there is nothing in CodingStyle for if () continuation
>lines.  Looks like it is needed.  This is ETOOMUCHINDENTATION by
>at least one tab.  Should be more like:
>
>+	if (machine_is_omap_h4()
>+	    || machine_is_omap_h3()
>+	    || machine_is_omap_h2()
>+	    || machine_is_omap_perseus2())

My stance, || goes at EOL, and final ) not standalone:

	if (foo ||
	  bar ||
	  baz ||
	  etc)
		do_something;



Jan
-- 
