Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXLVNLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXLVNLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbXLVNKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:10:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41337 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbXLVNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:10:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <476D0CCC.2050402@s5r6.in-berlin.de>
Date: Sat, 22 Dec 2007 14:10:36 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       krh@bitplanet.net, linux1394-devel@lists.sourceforge.net
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22	regression)
References: <4767A323.7090205@s5r6.in-berlin.de> <20071218.142956.26529678.davem@davemloft.net> <476947C1.2010405@s5r6.in-berlin.de> <20071220.004033.75315225.davem@davemloft.net> <20071220201901.GA30969@darkmoon.home>
In-Reply-To: <20071220201901.GA30969@darkmoon.home>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emanuele Rocca wrote:
> * David Miller <davem@davemloft.net>, [2007-12-20  0:40 -0800]:
>>  The problem is that I created indirection that was totally unused, the
>>  operation vectors members for these cases thus didn't get filled in,
>>  and we OOPS trying to call NULL pointers as functions :-)
>>  
>>  This should fix the crash:
> 
> It does, tested on a Sun Blade 2000.

Thanks David and Emanuele.  I haven't got feedback from the other
reporter yet but I assume this fixes the issue
(http://bugzilla.kernel.org/show_bug.cgi?id=9160).
-- 
Stefan Richter
-=====-=-=== ==-- =-==-
http://arcgraph.de/sr/
