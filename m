Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbXCTDrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbXCTDrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 23:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbXCTDrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 23:47:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33634
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933175AbXCTDrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 23:47:13 -0400
Date: Mon, 19 Mar 2007 20:47:12 -0700 (PDT)
Message-Id: <20070319.204712.118947830.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: ak@suse.de, virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, anthony@codemonkey.ws,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0703192015020.6730@woody.linux-foundation.org>
References: <20070319.120854.30182994.davem@davemloft.net>
	<200703192159.42396.ak@suse.de>
	<Pine.LNX.4.64.0703192015020.6730@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Mar 2007 20:18:14 -0700 (PDT)

> > > Please don't subject us to another couple months of hair-pulling only
> > > to have Linus yank the thing out again, there are certainly more
> > > useful things to spend time on :-)
> 
> Good call. Dwarf2 unwinding simply isn't worth doing. But I won't yank it 
> out, I simply won't merge it. It was more than just totally buggy code, it 
> was an inability of the people to understand that even bugfree code 
> isn't enough - you have to be able to also handle buggy data.

Thank you.
