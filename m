Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbXK2Wbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbXK2Wbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbXK2Wb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:31:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47897 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759881AbXK2Wb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:31:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <474F3D9C.3080701@s5r6.in-berlin.de>
Date: Thu, 29 Nov 2007 23:30:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.24-rc3-mm2
References: <20071128034140.648383f0.akpm@linux-foundation.org>	<64bb37e0711291258v1a51598bm36a1b953eab9fdd1@mail.gmail.com> <20071129130756.7550ce13.akpm@linux-foundation.org>
In-Reply-To: <20071129130756.7550ce13.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 29 Nov 2007 21:58:16 +0100
> "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>> First crash:
>>
>> [ 1116.083651] Unable to handle kernel NULL pointer dereference at
>> 0000000000000378 RIP:
>> [ 1116.089216]  [<ffffffff8047cb88>] ether1394_dg_complete+0x28/0xa0
...
> Yep, looks like a genuine 1394 bug.

I can't make head or tail of it.

FWIW, eth1394 and the entire rest of the 1394 stack beneath eth1394 are
identical between -mm and Linus' tree.
-- 
Stefan Richter
-=====-=-=== =-== ===-=
http://arcgraph.de/sr/
