Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbXLLCeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbXLLCeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXLLCd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:33:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60890 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXLLCd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:33:57 -0500
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <475F4422.6050000@linuxtv.org>
References: <1197424531.9563.6.camel@gaivota> <475F4422.6050000@linuxtv.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 12 Dec 2007 00:33:18 -0200
Message-Id: <1197426798.9563.15.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Ter, 2007-12-11 às 21:14 -0500, Michael Krufky escreveu:
> Mauro Carvalho Chehab wrote:
> > Please pull from:
> >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master
> >
> > [snip]
> >
> >   
> Mauro,
> > Mauro Carvalho Chehab (4):
> >       V4L/DVB (6750): Fix in-kernel compilation for cxusb
> >   
> ^^ This patch fixes a build issue that only applies to new devices that
> depend on the tuner-xc2028 module, which is planned to be added to
> mainline for 2.6.25 ....  We don't need to send this patch upstream yet,
> because the dependency doesn't exist in 2.6.24.

Hmm... ok. Anyway, It won't hurt to apply it. The patch just adds a
missing include directory to Makefile:
+EXTRA_CFLAGS += -Idrivers/media/video

Anyway, I'll remove it from the tree and send to linus an updated pull
request.

> > Benoit Istin (1):
> >       V4L/DVB (6746): saa7134-dvb: fix tuning for WinTV HVR-1110
> >
> >   
> ^^ This patch is good for 2.6.24, but it is only the first half of the
> fix.  This fixes digital tuning, but the analog fix is the following
> changeset:
> 
> saa7134: enable LNA in analog mode for Hauppauge WinTV HVR-1110
> http://linuxtv.org/hg/~mkrufky/oxford2/rev/b227949c41ad
> 
> Please send this one in your next pull request to Linus.
Ok.

I'll pull from your oxford2 tree and keep it for a while at development tree for testing.

> Regards,
> 
> Mike
-- 
Cheers,
Mauro

