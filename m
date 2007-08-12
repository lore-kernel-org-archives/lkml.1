Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbXHLJYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbXHLJYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbXHLJVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:21:37 -0400
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:4856 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933084AbXHLJVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:21:35 -0400
Date: Sun, 12 Aug 2007 11:21:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070812112153.59454e84@hyperion.delvare>
In-Reply-To: <46BDDA59.5070302@s5r6.in-berlin.de>
References: <46B5B290.4040907@s5r6.in-berlin.de>
	<20070805162141.GI6221@jupiter.solarsys.private>
	<46B6053E.2050708@s5r6.in-berlin.de>
	<20070810230831.59cbc50f@hyperion.delvare>
	<46BCE6D0.7060300@s5r6.in-berlin.de>
	<20070811135705.0d0688d7@hyperion.delvare>
	<46BDD8B3.8070708@s5r6.in-berlin.de>
	<46BDDA59.5070302@s5r6.in-berlin.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007 17:48:41 +0200, Stefan Richter wrote:
> Jean Delvare wrote:
>> So my theory is that something else (BIOS, ACPI?)
> 
> (ksensors?)

ACPI if my guess is correct.

>> is changing the bank,
>> probably to read temperature values which are in banks 1 and 2, causing
>> the w83627ehf to get a wrong value for the VBAT register. If I am
>> right, then the attached patch should help. Please give it a try and
>> report.
>
> This patch fixes the issue.  (I didn't reboot, only reloaded the drivers
> after patching.)
> 
> Thanks for your help and advice.

Great, thanks for testing and reporting. Mark, please add my patch to
your hwmon-testing queue, and send it to Linus in the next batch of
fixes.

If no problem is reported, we can get rid of w83627ehf_reset_bank() in
a later kernel version.

-- 
Jean Delvare
