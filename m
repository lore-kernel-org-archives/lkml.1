Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbXHKPtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbXHKPtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 11:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbXHKPsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 11:48:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43174 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbXHKPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 11:48:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BDDA59.5070302@s5r6.in-berlin.de>
Date: Sat, 11 Aug 2007 17:48:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
References: <46B5B290.4040907@s5r6.in-berlin.de>	<20070805162141.GI6221@jupiter.solarsys.private>	<46B6053E.2050708@s5r6.in-berlin.de>	<20070810230831.59cbc50f@hyperion.delvare>	<46BCE6D0.7060300@s5r6.in-berlin.de> <20070811135705.0d0688d7@hyperion.delvare> <46BDD8B3.8070708@s5r6.in-berlin.de>
In-Reply-To: <46BDD8B3.8070708@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jean Delvare wrote:
>> So my theory is that something else (BIOS, ACPI?)

(ksensors?)

>> is changing the bank,
>> probably to read temperature values which are in banks 1 and 2, causing
>> the w83627ehf to get a wrong value for the VBAT register. If I am
>> right, then the attached patch should help. Please give it a try and
>> report.

This patch fixes the issue.  (I didn't reboot, only reloaded the drivers
after patching.)

Thanks for your help and advice.
-- 
Stefan Richter
-=====-=-=== =--- -=-==
http://arcgraph.de/sr/
