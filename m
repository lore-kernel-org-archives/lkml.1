Return-Path: <linux-kernel-owner+w=401wt.eu-S964968AbXCFLfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968AbXCFLfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964980AbXCFLfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:35:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34246 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964968AbXCFLfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:35:54 -0500
Date: Tue, 6 Mar 2007 20:35:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-Id: <20070306203542.e9b3e133.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070306030927.bc2f15fc.akpm@linux-foundation.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070306192718.999e114d.kamezawa.hiroyu@jp.fujitsu.com>
	<20070306030927.bc2f15fc.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 03:09:27 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > ==
> > 
> > Is "mask"  always valid pointer ?
> 
> I can only find two `struct irq_chip's in arch/ia64 and they both have a
> .mask.  And a .unmask.  So perhaps that is a misreading of what oopsed.
> 
> There are no changes in kernel/irq/ in -mm.  Are you sure mainline doesn't
> do this too?
> 
> Anyway, can you please take a closer look at exactly what pointer it is
> oopsing on?
> 
Okay, I'll try -rc2 and look into more, tomorrow.

-Kame 

