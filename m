Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbXHSVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbXHSVKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 17:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXHSVKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 17:10:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60546 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbXHSVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 17:10:32 -0400
Subject: Re: sched.c: why -fno-omit-frame-pointer?
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andreas Schwab <schwab@suse.de>, Alan Modra <alan@linuxcare.com.au>,
       David Mosberger-Tang <davidm@hpl.hp.com>
In-Reply-To: <20070819141732.GD32595@stusta.de>
References: <20070819141732.GD32595@stusta.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 19 Aug 2007 14:05:23 -0700
Message-Id: <1187557523.19299.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-08-19 at 16:17 +0200, Adrian Bunk wrote:
> kernel/sched.c gets compiled with -fno-omit-frame-pointer, and this was 
> already done in kernel 1.0 (sic).
> 
> Later, it has been modified to be this way only on some architectures.
> 
> It might not be an earthshaking amount, but removing it saves some 
> bytes, and there's no visible breakage when running the modified kernel 
> on i386.
> 

vague memory: this was needed for wchan to work properly


