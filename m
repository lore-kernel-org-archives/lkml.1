Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbXLTMyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbXLTMyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXLTMyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:54:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49924
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbXLTMyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:54:04 -0500
Date: Thu, 20 Dec 2007 04:53:59 -0800 (PST)
Message-Id: <20071220.045359.107684960.davem@davemloft.net>
To: mpm@selenic.com
Cc: akpm@linux-foundation.org, m.kozlowski@tuxland.pl,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071217145554.GD19691@waste.org>
References: <20071216.202611.226170474.davem@davemloft.net>
	<20071216223917.873e34bf.akpm@linux-foundation.org>
	<20071217145554.GD19691@waste.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Mon, 17 Dec 2007 08:55:54 -0600

> On Sun, Dec 16, 2007 at 10:39:17PM -0800, Andrew Morton wrote:
> Actually, you may only need these two:
> 
> > maps4-add-proc-kpagecount-interface.patch
> > maps4-add-proc-kpageflags-interface.patch

Yes these two were enough, and exporting fs/proc/base.c's
mem_lseek().

As hard as I try, I can't reproduce this at all.  I tried
both on my workstation and my niagara boxes.

It must be other needle in the 30MB+ -mm haystack. :-(

