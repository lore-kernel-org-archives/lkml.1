Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbXGQSuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbXGQSuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbXGQStw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:49:52 -0400
Received: from iona.labri.fr ([147.210.8.143]:56367 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbXGQStv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:49:51 -0400
Date: Tue, 17 Jul 2007 20:49:43 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: James Simmons <jsimmons@infradead.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use tty_schedule in VT code.
Message-ID: <20070717184943.GA3768@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	James Simmons <jsimmons@infradead.org>,
	Linus Torvalds <torvalds@osdl.org>,
	Linux console project <linuxconsole-dev@lists.sourceforge.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons, le Tue 17 Jul 2007 19:37:57 +0100, a écrit :
> -	schedule_delayed_work(&t->buf.work, 0);

It was schedule_delayed_work(&t->buf.work, 1); in con_schedule_flip() ;
could that matter?

Samuel
