Return-Path: <linux-kernel-owner+w=401wt.eu-S2992514AbXDDANb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992514AbXDDANb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992511AbXDDANb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:13:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36730 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992514AbXDDANa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:13:30 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070403.170212.02298297.davem@davemloft.net>
References: <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403212928.GA12951@cynthia.pants.nu>
	 <1175644642.10567.31.camel@shinybook.infradead.org>
	 <20070403.170212.02298297.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 20:12:48 -0400
Message-Id: <1175645568.10567.42.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 17:02 -0700, David Miller wrote:
> Sparc does the same thing, it's a common convention and you really
> should not break it.

I thought that argument was lost many years ago. It _used_ to be a
common convention; we got better.

> Every powerpc and sparc system out that is using ttyS0 with dynamic
> minor numbers being allocated.  I really think this should be
> generalized instead of breaking serial on every powerpc machine out
> there.

Nobody's breaking anything. The patch _fixes_ serial, and allows powerpc
machines to use both z8530 and 8250 ports at the same time; something
which has been broken for a long time.

-- 
dwmw2

