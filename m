Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbXJXVgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbXJXVgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXJXVgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:36:33 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:65454 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbXJXVgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:36:32 -0400
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc1]EXPORT_SYMBOL(__set_page_dirty_no_writeback);
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710250015.FFG17175.LSHOMOFVJFOFtQ@I-love.SAKURA.ne.jp>
	<20071024091027.541d2e98@laptopd505.fenrus.org>
In-Reply-To: <20071024091027.541d2e98@laptopd505.fenrus.org>
Message-Id: <200710250636.JHG87098.VtOSQMFJOHLOFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 25 Oct 2007 06:36:27 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Arjan van de Ven wrote:
> > I think __set_page_dirty_no_writeback should be exported so that
> > tmpfs-like filesystems can use it.
> which filesystem is ACTUALLY using it?
> Please submit the export together with the actual user; we have too
> many unused exports already; the only way to remotely deal with that
> problem is to merge the exports together with the actual code...
tmpfs is using it, but tmpfs is always built-in.
I'm using a filesystem that is alike tmpfs.

