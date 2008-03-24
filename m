Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbYCXMlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbYCXMlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 08:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbYCXMkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 08:40:55 -0400
Received: from mx05.stofanet.dk ([212.10.10.25]:38208 "EHLO mx05.stofanet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbYCXMky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 08:40:54 -0400
X-Greylist: delayed 3706 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2008 08:40:54 EDT
Message-ID: <47E792D4.7000704@yahoo.co.uk>
Date: Mon, 24 Mar 2008 12:39:00 +0100
From: "Martin B. Andersen" <datscharf@yahoo.co.uk>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: MMC/SD: data CRC errors and unknown SCR version on 2.6.14
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am having some problems with a couple of SD cards which isn't detected 
correctly when inserted, I have seen this with both Sandisk and Kingston 
cards. I am sorry to bring up issues with this old driver version, I 
know there has been done a lot of work after 2.6.14 with the driver.

...but the setup is this: I have backported the mmc driver from kernel 
2.6.14 to 2.6.12 for my own reasons. I wasn't able to use a newer 
version as the driver interface had changed too much to be feasible.

When inserting a faulty card I can see, when debug output is enabled, 
that the communication and output is identical with a working card up 
until the SCR part. Here the driver reports a data CRC error but 
continues, and then it reports an unknown SCR version either 15 or 3, 
but I gather that the array with the SCR contains junk at this point so 
the SCR version is not to be taken seriously. Some times however it is 
able to succesfully detect and register the card, this is mostly seen 
the first time the driver is loaded, afterwards it keeps failing. Has 
anybody seen this behavior before? Is it timing issues or is it caused 
by faulty cards?

best regards
Martin
