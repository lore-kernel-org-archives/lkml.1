Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbXLLCh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbXLLCh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXLLChR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:37:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42152 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXLLChO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:37:14 -0500
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1197426798.9563.15.camel@gaivota>
References: <1197424531.9563.6.camel@gaivota> <475F4422.6050000@linuxtv.org>
	 <1197426798.9563.15.camel@gaivota>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 00:36:38 -0200
Message-Id: <1197426998.9563.18.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ^^ This patch fixes a build issue that only applies to new devices
> that
> > depend on the tuner-xc2028 module, which is planned to be added to
> > mainline for 2.6.25 ....  We don't need to send this patch upstream yet,
> > because the dependency doesn't exist in 2.6.24.
> 
> Hmm... ok. Anyway, It won't hurt to apply it. The patch just adds a
> missing include directory to Makefile:
> +EXTRA_CFLAGS += -Idrivers/media/video
> 
> Anyway, I'll remove it from the tree and send to linus an updated pull
> request.

Linus already pulled from my tree. There's no need to revert this
changeset. It will not hurt and will be needed soon, anyway.

-- 
Cheers,
Mauro

