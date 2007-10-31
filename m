Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbXJaHod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbXJaHod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXJaHo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:44:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49408
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbXJaHoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:44:25 -0400
Date: Wed, 31 Oct 2007 00:44:25 -0700 (PDT)
Message-Id: <20071031.004425.12962203.davem@davemloft.net>
To: npiggin@suse.de
Cc: duaneg@dghda.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071031074106.GE12189@wotan.suse.de>
References: <20071031064221.GC12189@wotan.suse.de>
	<20071030.235600.254712083.davem@davemloft.net>
	<20071031074106.GE12189@wotan.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Wed, 31 Oct 2007 08:41:06 +0100

> On Tue, Oct 30, 2007 at 11:56:00PM -0700, David Miller wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > Date: Wed, 31 Oct 2007 07:42:21 +0100
> > 
> > Anyways, my core suggestion is to add a hook here so platforms can
> > do the remote register fetch if they want.
> 
> You could possibly even do a generic "best effort" kind of thing with
> regular IPIs, that will timeout and continue if some CPUs don't handle
> them, and should be pretty easy to get working with existing smp_call_
> function stuff. Not exactly clean, but it would be better than nothing.

Without a doubt.
