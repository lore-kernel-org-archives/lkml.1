Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXENGsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXENGsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXENGsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:48:33 -0400
Received: from www.osadl.org ([213.239.205.134]:47860 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754096AbXENGsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:48:32 -0400
Subject: Re: [patch 4/4] powerpc 2.6.21-rt1: reduce scheduling latency by
	changing tlb flush size
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <yyiveev9afk.wl@toshiba.co.jp>
References: <yyi3b1zapqa.wl@toshiba.co.jp> <yyiwszb9asq.wl@toshiba.co.jp>
	 <yyiveev9afk.wl@toshiba.co.jp>
Content-Type: text/plain
Date: Mon, 14 May 2007 08:51:46 +0200
Message-Id: <1179125506.22481.297.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tsutomu-san,

On Mon, 2007-05-14 at 15:38 +0900, Tsutomu OWA wrote:
> Oopps, Subject was wrong.... resending it.  Sorry.
> 
> To reduce scheduling latecy by changing tlb flush size to 1.
> Since tlb flush on Celleb is done by calling (an) expensive hypervisor call(s), 
> it takes a long time to flush tlbs and causes scheduing latency.
> 
> As I don't know how long it takes on other platforms, it would be better to 
> enclose it within #ifdef CONFIG_PPC_CELLEB.

Yes, that might be appropriate. Can you add this and resend please ?

	tglx


