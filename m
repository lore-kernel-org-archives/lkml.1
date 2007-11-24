Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbXKXUWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbXKXUWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 15:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXKXUWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 15:22:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41180 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbXKXUWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 15:22:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47488808.2000104@s5r6.in-berlin.de>
Date: Sat, 24 Nov 2007 21:22:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: (solved) Re: Linux 2.6.24-rc* regression: sensors says "No sensors
 found"
References: <4748606D.6050501@s5r6.in-berlin.de> <474861FB.1080104@s5r6.in-berlin.de>
In-Reply-To: <474861FB.1080104@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Stefan Richter wrote:
>> I just booted 2.6.24-rc3 on two different PCs, one with i945 based MSI
>> motherboard and i386 kernel and one with i945 based Apple motherboard
>> and x86-64 kernel.  Before that I ran linux 2.6.23.
>>
>> On both PCs, "sensors" exits with
>>> No sensors found!
> 
> now logged at http://bugzilla.kernel.org/show_bug.cgi?id=9451

Updating sysfsutils from version 1.3.0 to 2.1.0 cured this on both PCs.
Thanks to Jean for pointing me to sysfsutils.
-- 
Stefan Richter
-=====-=-=== =-== ==---
http://arcgraph.de/sr/
