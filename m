Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXIKTqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXIKTqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761254AbXIKTqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:46:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38491 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbXIKTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:46:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46E6F076.5000006@s5r6.in-berlin.de>
Date: Tue, 11 Sep 2007 21:45:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ben Collins <ben.collins@ubuntu.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: regression: fireware causes oops during system
References: <20070911190043.GA1577@elf.ucw.cz> <1189537716.7620.192.camel@cunning> <46E6ECAA.30601@s5r6.in-berlin.de>
In-Reply-To: <46E6ECAA.30601@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Tue, 2007-09-11 at 21:00 +0200, Pavel Machek wrote:
>>> I noticed empty suspend stopped working around 2.6.23-rc4, and it is
>>> still present in 2.6.23-rc6.
...
>>> Unsetting
>>>
>>> CONFIG_IEEE1394=y
>>>
>>> solves the problem.
...

Between -rc3 and -rc4:

	ieee1394: sbp2: fix sbp2_remove_device for error cases
	a2ee3f9bbb0ce57102dad8928d54f59acdc4b8f7
	should not occur in suspend path

Between -rc1 and -rc2:

	ieee1394: sbp2: more correct Kconfig dependencies
	e4f8cac5e07528f7e0bc21d3682c16c9de993ecb
	unrelated

	ieee1394: revert "sbp2: enforce 32bit DMA mapping"
	a9c2f18800753c82c45fc13b27bdc148849bdbb2
	unrelated

	(not via linux1394-2.6.git)
	raw1394 __user annotation
	5b26e64ea39e45802c5736c8261bf8a8704d212f
	unrelated

So it must be something older which was somehow uncovered.
Dmesg with the oops or/and bisection would be good.
-- 
Stefan Richter
-=====-=-=== =--= -=-==
http://arcgraph.de/sr/
