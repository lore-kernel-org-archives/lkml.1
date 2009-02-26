Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZBZJ0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZBZJ0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 04:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZBZJ0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 04:26:34 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:45587 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZBZJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 04:26:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fykIi/woznlrjGTBmpVQVL9I7xoCN0xhLNwgv+2WnCmeWZrAxF0lUq47F6a2DIagfJ
         5yHZ/H9KafhEoHGbxB58irhvx8cnUplU/lMhRB/Rl8xVV+cR7KWWYCUqAXk8s57fryM2
         rUAZi5wkIXKD6BMpDO5hL/hZC0df8nv5eoSb8=
MIME-Version: 1.0
In-Reply-To: <1235639427.11390.11.camel@minggr>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
	 <1235639427.11390.11.camel@minggr>
Date: Thu, 26 Feb 2009 11:26:29 +0200
X-Google-Sender-Auth: 72650230b27ffcb5
Message-ID: <84144f020902260126g589be187j5c5f52e1d8e13abf@mail.gmail.com>
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n1Q9QswM021630

On Thu, Feb 26, 2009 at 11:10 AM, Lin Ming <ming.m.lin@intel.com> wrote:> We tested this v2 patch series with 2.6.29-rc6 on different machines.
What .config is this? Specifically, is SLUB or SLAB used here?
>>                4P qual-core    2P qual-core    2P qual-core HT>                tigerton        stockley        Nehalem>                ------------------------------------------------> tbench          +3%             +2%             0%> oltp            -2%             0%              0%> aim7            0%              0%              0%> specjbb2005     +3%             0%              0%> hackbench       0%              0%              0%>> netperf:> TCP-S-112k      0%              -1%             0%> TCP-S-64k       0%              -1%             +1%> TCP-RR-1        0%              0%              +1%> UDP-U-4k        -2%             0%              -2%> UDP-U-1k        +3%             0%              0%> UDP-RR-1        0%              0%              0%> UDP-RR-512      -1%             0%              +1%ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
