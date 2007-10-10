Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbXJJBVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbXJJBVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 21:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXJJBVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 21:21:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56199 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbXJJBVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:21:24 -0400
Subject: Re: [PATCH 3/3] V4L: cinergyT2, remove bad usage of ERESTARTSYS
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       daniel@qanu.de, holger@qanu.de, video4linux-list@redhat.com,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
In-Reply-To: <24841282012868130110@pripojeni.net>
References: <24841282012868130110@pripojeni.net>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 09 Oct 2007 22:21:00 -0300
Message-Id: <1191979260.5492.32.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Em Seg, 2007-10-08 às 13:41 +0100, Jiri Slaby escreveu:
> cinergyT2, remove bad usage of ERESTARTSYS
> 
> test of cinergyt2->disconnect_pending doesn't ensure pending signal and so
> ERESTARTSYS would reach userspace, which is not permitted. Change it to
> EAGAIN
> 

checkpatch.pl is complaining about your changeset:

do not use assignment in if condition
#82: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:492:
+     if ((err = mutex_lock_interruptible(&cinergyt2->wq_sem)))

do not use assignment in if condition
#86: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:495:
+     if ((err = mutex_lock_interruptible(&cinergyt2->sem)))

do not use assignment in if condition
#133: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:1036:
+     if ((err = mutex_lock_interruptible(&cinergyt2->wq_sem)))

do not use assignment in if condition
#137: FILE: drivers/media/dvb/cinergyT2/cinergyT2.c:1039:
+     if ((err = mutex_lock_interruptible(&cinergyt2->sem)))

Please fix.

Cheers,
Mauro

