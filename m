Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYBKWtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYBKWtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYBKWtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:49:16 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58187 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYBKWtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:49:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B0D0AF.2050200@s5r6.in-berlin.de>
Date: Mon, 11 Feb 2008 23:48:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25-rc1
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>	<64bb37e0802111346q13ddc3fy60edfce0daff3bf@mail.gmail.com> <20080211141504.4fef4e74.akpm@linux-foundation.org>
In-Reply-To: <20080211141504.4fef4e74.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 11 Feb 2008 22:46:18 +0100
> "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>> The system is a dual opteron x86_64 system with 4 GB ECC RAM and an
>> nVidia 3600 chipset (MCP55).
>> As noted in the rc3-mm2-thread the crash will also happen, if I use
>> normal ethernet instead of ether1394.
> 
> But this is a crash inside the 1394 code.  So if you're getting a crash
> with plain-old-ethernet then it is a different crash.  It'd be good if we
> could see the oops trace for that one too please.

There are no bugs in 1394. :-)

Here are two postings from Torsten which I found in my mail archive.

2007-11-29, an IP-over-1394 backtrace + an ethernet backtrace:
http://marc.info/?l=linux-kernel&m=119636996902805

2007-12-03, a backtrace in the TCP code:
http://marc.info/?l=linux-kernel&m=119671371413299
-- 
Stefan Richter
-=====-==--- --=- -=-==
http://arcgraph.de/sr/
