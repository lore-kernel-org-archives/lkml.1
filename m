Return-Path: <linux-kernel-owner+w=401wt.eu-S1751302AbZI1Fe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbZI1Fe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 01:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbZI1Fe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 01:34:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38045 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZI1Fe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 01:34:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Sep 2009 14:32:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-Id: <20090928143246.ffed3413.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4AC04800.70708@crca.org.au>
References: <4AB9A0D6.1090004@crca.org.au>
	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABC80B0.5010100@crca.org.au>
	<20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC0234F.2080808@crca.org.au>
	<20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090928033624.GA11191@localhost>
	<20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC03D9C.3020907@crca.org.au>
	<20090928135315.083aca18.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC04800.70708@crca.org.au>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 15:22:08 +1000
Nigel Cunningham <ncunningham@crca.org.au> wrote:

> Hi.
> 
> KAMEZAWA Hiroyuki wrote:
> > Seems good to me.
> > 
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > But
> >> +	if (vma->vm_hints)
> >> +		return 0;
> >>  	return 1;
> > 
> > Maybe adding a comment (or more detailed patch description) is necessary.
> 
> Thinking about this some more, I think we should also be looking at whether the new hints are non zero. Perhaps I should just add the new value to the
> function parameters and be done with it.
> 
No objections from me. plz do.
I said option (1) just because patch size will be big to unexpected.
Thank you for your effort.

Regards,
-Kame

