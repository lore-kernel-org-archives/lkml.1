Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZGIEyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZGIEyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbZGIEyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:54:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64407 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZGIEyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:54:17 -0400
Content-return: prohibited
Date: Thu, 09 Jul 2009 04:54:10 +0000 (GMT)
From: NARAYANAN GOPALAKRISHNAN <narayanan.g@samsung.com>
Subject: Re: Re: Performance degradation seen after using one list for hot/cold
 pages.
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Cc: "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Reply-to: narayanan.g@samsung.com
Message-id: <23853191.513591247115250186.JavaMail.weblogic@epml10>
MIME-version: 1.0
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
X-Priority: 3
Msgkey: 20090709044753090@narayanan.g
X-MTR: 20090709044753090@narayanan.g
X-EPLocale: en_US.windows-1252
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 
X-ParentMTR: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n694t1Xx000977


> I'll add the rather important text:
> 
> Fix a post-2.6.24 performance regression caused by
> 3dfa5721f12c3d5a441448086bee156887daa961 ("page-allocator: preserve PFN
> ordering when __GFP_COLD is set").
>
> This was a pretty major screwup.
>
> This is why changing core MM is so worrisome - there's so much secret and
> subtle history to it, and performance dependencies are unobvious and quite
> indirect and the lag time to discover regressions is long.
> 
> Narayanan, are you able to quantify the regression more clearly?  All I
> have is "2 MBps lower" which isn't very useful.  What is this as a
> percentage, and with what sort of disk controller?  Thanks.

It is around 15%. There is no disk controller as our setup is based on Samsung OneNAND
used as a memory mapped device on a OMAP2430 based board.

Narayanan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
