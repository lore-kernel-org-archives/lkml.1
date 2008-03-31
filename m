Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYCaMwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYCaMwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYCaMwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:52:44 -0400
Received: from smtp.nokia.com ([192.100.105.134]:27893 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYCaMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:52:43 -0400
Message-ID: <47F0DD49.7010302@nokia.com>
Date: Mon, 31 Mar 2008 15:47:05 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: ext Jan Engelhardt <jengelh@computergmbh.de>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: [RFC PATCH] UBIFS - new flash file system
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2008 12:52:23.0571 (UTC) FILETIME=[108FFE30:01C8932E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> On Thursday 2008-03-27 15:55, Artem Bityutskiy wrote:
>>
>> here is a new flash file system developed by Nokia engineers with
>> help of the University of Szeged. The new file-system is called
>> UBIFS, which stands for UBI file system. UBI is the wear-leveling/
>> bad-block handling/volume management layer which is already in
>> mainline (see drivers/mtd/ubi).
>> [...]
> 
> And how does it compare to logfs?

We don't know a lot about logfs, so you will really have to make
your own comparison.  However our general impressions are as follows:

1. In our testing logfs file operations seem to be much slower,
see http://osl.sed.hu/wiki/ubifs/index.php/IOzone

2. logfs code base is much smaller i.e.  UBIFS has 3-4 times as many
lines of code.

3. logfs does not seem to have bad-block handling.

4. logfs does not seem to have wear-leveling.

5. We are not certain how scalable logfs is.

We could be wrong about those things - don't flame us if we are.
Ask us about UBIFS, not logfs.
