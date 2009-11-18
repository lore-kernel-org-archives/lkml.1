Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZKRBjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZKRBjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZKRBjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:39:10 -0500
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:33206
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbZKRBjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:39:10 -0500
In-Reply-To: <1258468075.2971.6.camel@iscandar.digidescorp.com>
To: steve@digidescorp.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       Lennox Wu <lennox.wu@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH] microblaze: Fix pfn_valid() for noMMU
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF94FA6DBC.7FC9A140-ON48257672.00081DD4-48257672.000909A3@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 18 Nov 2009 09:37:50 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/11/18 ?? 09:37:52,
	Serialize complete at 2009/11/18 ?? 09:37:52
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAI1dU16022184

"Steven J. Magnani" <steve@digidescorp.com> Ğ´ÓÚ 2009-11-17 22:27:54:

> On Mon, 2009-11-16 at 14:14 -0800, Andrew Morton wrote:
> > On Fri, 13 Nov 2009 16:08:29 -0600
> > steve@digidescorp.com wrote:
> > 
> > > Configuring DEBUG_SLAB causes a noMMU kernel to die during 
initialization
> > > with an invalid virtual address panic in kfree_debugcheck().
> > > The panic is due to an improper definition of pfn_valid().
> > > 
> > > ...
> > Is arch/score/include/asm/page.h buggy also?
> > 
> 
> I don't believe so, but only because MEMORY_START is defined as zero for
> that arch, making min_low_pfn zero.
> 

Yes, it's right because MEMORY_START is defined as 0,
make min_low_pfn to zero and max_mapnr equal max_low_pfn.

We will fix it to make code more clear.

liqin

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
