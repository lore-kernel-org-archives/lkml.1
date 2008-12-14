Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYLNAi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYLNAi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 19:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYLNAiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 19:38:22 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51170 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYLNAiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 19:38:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4944557A.7060902@s5r6.in-berlin.de>
Date: Sun, 14 Dec 2008 01:38:18 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] ieee1394: mark bus_info_data was a __be32 array
References: <1229209354.11257.11.camel@brick>
In-Reply-To: <1229209354.11257.11.camel@brick>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Two access functions get_max_rom and set_hw_config_rom are
> changed to take __be32 as well.  Only bus_info_data was
> ever passed in so this is OK.  All other uses of bus_info_data
> treated it as a be32 value already.

I pushed the following out to linux1394-2.6.git:

Harvey Harrison (6):
      ieee1394: pcilynx: trivial endian annotation
      ieee1394: replace CSR_SET_BUS_INFO_GENERATION macro
      ieee1394: mark bus_info_data as a __be32 array
      ieee1394: eth1394: trivial sparse annotations
      ieee1394: dv1394 annotate frame input/output structs as little endian
      ieee1934: dv1394: interrupt enabling/disabling broken on big-endian

Note, I dropped two hunks from "mark bus_info_data..." due to another
change which I posted only a few hours ago.  Please check:
http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=commitdiff;h=d88b81b772c6db76eb3b9f9564034f55d0dcdd09
This interfered with your patch:
http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=commitdiff;h=6b09b72cbdcba8da71b85651eb37e0156aa65def

I pulled your patches into my master branch but not yet into my for-next
branch (awaiting possible feedback on what I enqueued before your patches).
-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/
