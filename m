Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbXGHElh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbXGHElh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 00:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXGHElb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 00:41:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26945 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXGHEla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 00:41:30 -0400
Date: Sat, 7 Jul 2007 21:43:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SLAB corruption
Message-Id: <20070707214359.11c5cb46.randy.dunlap@oracle.com>
In-Reply-To: <20070708005807.GV3885@ics.muni.cz>
References: <20070708005807.GV3885@ics.muni.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007 02:58:07 +0200 Lukas Hejtmanek wrote:

> Hello,
> 
> I'm trying to get to work InfiniBand card (Mellanox) in Xen and DomU. 
> 
> If I use SLAB_DEBUG I got the following message:
> Slab corruption: start=ffff880098f513b8, len=256
> Redzone: 0x1600000016/0x1700000017.
> Last user: <0000001800000018>(0x1800000018)
> 000: 17 00 00 00 17 00 00 00 18 00 00 00 18 00 00 00
> 010: 19 00 00 00 19 00 00 00 1a 00 00 00 1a 00 00 00
> 020: 1b 00 00 00 1b 00 00 00 1c 00 00 00 1c 00 00 00
> 030: 1d 00 00 00 1d 00 00 00 1e 00 00 00 1e 00 00 00
> 040: 1f 00 00 00 1f 00 00 00 00 00 00 00 00 00 00 00
> 050: 01 00 00 00 01 00 00 00 02 00 00 00 02 00 00 00
> Prev obj: start=0000000398f5120b, len=256
> Unable to handle kernel paging request at 0000000398f5130b RIP:
>  <ffffffff80277313> print_objinfo+0x22/0xde
> 
> 
> Could anyone give me some hints how to track down the SLAB corruption?

have you already looked at Documentation/vm/slub.txt ?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
