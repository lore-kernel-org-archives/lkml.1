Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYKXRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYKXRSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYKXRST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:18:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:58256 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbYKXRSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:18:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,660,1220252400"; 
   d="scan'208";a="363761362"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Hitoshi Mitake <h.mitake@gmail.com>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Date: Mon, 24 Nov 2008 09:18:13 -0800
Subject: RE: [PATCH 1/1] edac x38: new MC driver module
Thread-Topic: [PATCH 1/1] edac x38: new MC driver module
Thread-Index: AclNxxnVgaOhxyaZRM693RYL6NSq+AAkVBBw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35C517F42@orsmsx505.amr.corp.intel.com>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
	<20081106164641.ed369060.akpm@linux-foundation.org>
	<20081107152830.a42766f3.mitake@clustcom.com>
	<20081106223122.8a255211.akpm@linux-foundation.org>
	<20081107153824.0ec934e6.mitake@clustcom.com>
	<20081106231102.aab83cd4.akpm@linux-foundation.org>
	<a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>
	<20081109112646.97c594b5.akpm@linux-foundation.org>
	<20081118121620.GB8625@linux-mips.org>
	<20081118123215.GB30509@flint.arm.linux.org.uk>
 <20081121011941.26e05a25.h.mitake@gmail.com> <4929ECB7.8080108@zytor.com>
In-Reply-To: <4929ECB7.8080108@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mAOHJ7dq027642

>       volatile u32 __iomem *__p = addr;
>       u32 __l, __h;

Do we really need all the "__" inside an inline function?  Why
not just call these "p", "l" and "h"?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
