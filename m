Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbYLCVmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbYLCVmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYLCVmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:42:11 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:63873 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbYLCVmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:42:10 -0500
To: shemminger@vyatta.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: mmotm 2008-11-26-17-00 uploaded
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
	<200811282209.FDC95384.tLQJFOFOHFMSOV@I-love.SAKURA.ne.jp>
	<20081128114257.a651b9ee.akpm@linux-foundation.org>
	<20081203075254.3bcb3220@extreme>
In-Reply-To: <20081203075254.3bcb3220@extreme>
Message-Id: <200812040642.FFB65682.QSVJMHOOFLtFOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 4 Dec 2008 06:42:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Stephen Hemminger wrote:
> > > [   24.978638] BUG: unable to handle kernel NULL pointer dereference at 00000004
> > > [   24.980541] IP: [<c056bfb7>] loopback_get_stats+0x26/0x51
> > 
> > At a guess I'd say that local variable `stats' in loopback_get_stats()
> > is null.
> > 
> > but it's a bit hard to see how that change could cause the crash which
> > you observed.
> 
> Could be that some other code is stomping on per-cpu variables?

I don't know what was the cause, but mmotm 2008-12-02-17-08 is working fine.

Thanks.
