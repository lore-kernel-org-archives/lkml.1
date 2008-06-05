Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbYFEC74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbYFEC74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 22:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYFEC7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 22:59:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60004 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYFEC7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 22:59:48 -0400
Date: Thu, 05 Jun 2008 11:58:56 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87fxrtaqwl.fsf@saeurebad.de>
References: <20080604193712.97A9.E1E9C6FF@jp.fujitsu.com> <87fxrtaqwl.fsf@saeurebad.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080605115235.6453.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

> > I'd like to straggle more, but may be need more time,
> > because, IA64 doesn't have early_printk, and console is not enable
> > at here.....
> 
> Hm, just to make sure: this is the patch that breaks booting, right?  If
> you apply all patches in the series before this one, the machine boots
> fine?

Yes.

> 
> Could you boot a working image with bootmem_debug in the command line?
> Perhaps seeing the usual bootmem usage on this box gives a hint what is
> broken.

Ok. I'll try it.

> > P.S.
> > I was very confused by local variable namimng in alloc_bootmem_core. 
> > I suppose start, max, and end, should be named like
> > sidx, eidx, and midx. They are not pfn, but index of bitmap.
> 
> Okay, I will make them more clear.

Thanks.

> > However, new_start and new_end should be named as new_start_offset and
> > new_end_offset. They are not index, but offset from start address of
> > the node.
> 
> Yes, that too.  I would also rename last_offset to last_eidx and
> last_success to last_sidx.  What do you think?

Last_sidx is ok. But, last_offset seems to be used to manage some
allocated smaller chunks than one page. I'm not sure last_eidx is ok.


Bye.

-- 
Yasunori Goto 


