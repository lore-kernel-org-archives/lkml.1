Return-Path: <linux-kernel-owner+w=401wt.eu-S938924AbXGSOxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938924AbXGSOxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938804AbXGSOww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:52:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49445 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938777AbXGSOwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:52:49 -0400
Date: Thu, 19 Jul 2007 23:51:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, nickpiggin@yahoo.com.au,
       mike@stroyan.net, dmosberger@gmail.com, y-goto@jp.fujitsu.com
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
Message-Id: <20070719235157.9715baff.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <469F71E7.4050200@bull.net>
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>
	<20070719155632.7dbfb110.kamezawa.hiroyu@jp.fujitsu.com>
	<469F5372.7010703@bull.net>
	<20070719220118.73f40346.kamezawa.hiroyu@jp.fujitsu.com>
	<469F71E7.4050200@bull.net>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 16:15:03 +0200
Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:

> We may have, say 1 Gbyte / sec local i/o activity (using some RAIDs).
> Assume a few % of this 1 Gbyte is the program execution, or program swap in.
> It gives some hundreds of new exec pages / sec =>
> some msec-s can be lost each sec.
> 
> I can agree that it should not be a big deal :-)
> 
Hmm...but the current code flushes the page. just do it in "lazy" way.
much difference ?

-Kame
