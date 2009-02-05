Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbZBEJ4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbZBEJ4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZBEJ4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:56:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44158
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbZBEJ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:56:22 -0500
Date: Thu, 05 Feb 2009 01:56:18 -0800 (PST)
Message-Id: <20090205.015618.07025555.davem@davemloft.net>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: mel@csn.ul.ie, heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090205183409.1a12c23b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090205180617.8ee3dfb5.kamezawa.hiroyu@jp.fujitsu.com>
	<20090205.012123.141238531.davem@davemloft.net>
	<20090205183409.1a12c23b.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 5 Feb 2009 18:34:09 +0900

> On Thu, 05 Feb 2009 01:21:23 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > early_pfn_in_nid() returns true or false, not the found nid
> > 
> > I think you meant to change this to call early_pfn_to_nid()
> > 
> sorry..
> 
> > I'll make that correction and test your patch.
> > 
> > BTW, if you make that conversion there is no need for
> > early_pfn_in_nid() since there will be no other users.
> > 
> 
> Thanks, maybe the patch will be like this.

I tested this and I can no longer reproduce the problem.

Thanks!
