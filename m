Return-Path: <linux-kernel-owner+w=401wt.eu-S1765049AbXGQTRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765049AbXGQTRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758539AbXGQTR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:17:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47222 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbXGQTR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:17:26 -0400
Date: Tue, 17 Jul 2007 20:17:22 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: Linus Torvalds <torvalds@osdl.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <20070717184943.GA3768@interface.famille.thibault.fr>
Message-ID: <Pine.LNX.4.64.0707172016470.9131@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
 <20070717184943.GA3768@interface.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1831524198-1940100026-1184699842=:9131"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1831524198-1940100026-1184699842=:9131
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT


> James Simmons, le Tue 17 Jul 2007 19:37:57 +0100, a écrit :
> > -	schedule_delayed_work(&t->buf.work, 0);
> 
> It was schedule_delayed_work(&t->buf.work, 1); in con_schedule_flip() ;
> could that matter?

I did not detect any regressions.

---1831524198-1940100026-1184699842=:9131--
