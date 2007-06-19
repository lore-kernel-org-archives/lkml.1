Return-Path: <linux-kernel-owner+w=401wt.eu-S1765992AbXFSAM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765992AbXFSAM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbXFSAMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:12:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59811 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbXFSAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:12:51 -0400
Subject: Re: Change in default vm_dirty_ratio
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tim.c.chen@linux.intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.98.0706181700280.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
	 <20070618164711.9de1c38e.akpm@linux-foundation.org>
	 <alpine.LFD.0.98.0706181700280.3593@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 18 Jun 2007 17:09:53 -0700
Message-Id: <1182211793.2707.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Is it good to keep tons of dirty stuff around? Sure. It allows overwriting 
> (and thus avoiding doing the write in the first place), but it also allows 
> for a more aggressive IO scheduling, in that you have more writes that you 
> can schedule.


it also allows for an elevator that can merge more so that there are
less seeks...


so it's not all pure artificial ;(

I really don't like doing just-for-benchmark tuning ... but I wonder how
much real workloads this will get too (like installing or upgrading a
bunch of rpms)

As for the smoother IO thing.. there's already a kernel process that
writes this lot out after 5 seconds... so that ought to smooth some of
this out already.... I would hope.

(I'm not arguing this change is wrong, I'm just grinding my teeth on how
long updating rpms already takes... for no apparent reason)

