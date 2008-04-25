Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbYDYAZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbYDYAZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYDYAZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:25:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:53904 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbYDYAZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:25:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,706,1199692800"; 
   d="scan'208";a="237568286"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [git pull] ia64 changes
Date: Thu, 24 Apr 2008 17:25:06 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC012F9F55@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080425001652.GD18854@cs181133002.pp.htv.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [git pull] ia64 changes
Thread-Index: AcimacfnAxo1seyJQuWZF+17hnG1PQAADvug
References: <1FE6DD409037234FAB833C420AA843EC012F9EF0@orsmsx424.amr.corp.intel.com> <20080425001652.GD18854@cs181133002.pp.htv.fi>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Adrian Bunk" <bunk@kernel.org>
Cc: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>, "Mike Travis" <travis@sgi.com>,
       "Russ Anderson" <rja@sgi.com>
X-OriginalArrivalTime: 25 Apr 2008 00:25:07.0619 (UTC) FILETIME=[D0946730:01C8A66A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3P0PaEB022982

>>       Build fix for CONFIG_NUMA=y && CONFIG_SMP=n
>>...
>
> Why is this an allowed configuration on ia64?

It shows up in allnoconfig ... probably because some
bit of Kconfig forces NUMA=y.

I can't imagine that it is ever a useful combination ... except to
find places in the code where people have:

#if defined(CONFIG_SMP)
 ...
#else

#if defined(CONFIG_NUMA) // !!! SMP=n, NUMA code???
  ...
#endif
#endif


Which is what happened, and is being fixed, here.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
