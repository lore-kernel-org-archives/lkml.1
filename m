Return-Path: <linux-kernel-owner+w=401wt.eu-S1751290AbZIGTaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbZIGTaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbZIGTaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:30:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56240 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZIGTaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:30:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AA55EE5.10102@s5r6.in-berlin.de>
Date: Mon, 07 Sep 2009 21:28:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: pageexec@freemail.hu
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 2/6] firewire: ohci: fix Self ID Count register mask (safeguard
 against buffer overflow)
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>, <tkrat.e40ffd9ba52485e5@s5r6.in-berlin.de> <4AA5575E.6620.3D14E038@pageexec.freemail.hu>
In-Reply-To: <4AA5575E.6620.3D14E038@pageexec.freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pageexec@freemail.hu wrote:
> On 6 Sep 2009 at 18:49, Stefan Richter wrote:
> 
> added stable as .30 is affected, possibly older kernels as well, i didn't check.

The mistake which is fixed here is present since firewire-ohci was added 
in 2.6.22.  However, for a smooth submission to stable, the patched file...

>> --- linux-2.6.31-rc9.orig/drivers/firewire/ohci.c
>> +++ linux-2.6.31-rc9/drivers/firewire/ohci.c

...has to be drivers/firewire/fw-ohci.c in kernels before 2.6.31-rc1.

As hinted at in the changelog, I personally don't consider the fix 
urgent because there are a few more self ID consistency checks in place 
which catch a variety of real and theoretical corruptions, but I don't 
claim that I'm appropriately aware of all possibilities.
-- 
Stefan Richter
-=====-==--= =--= --===
http://arcgraph.de/sr/
