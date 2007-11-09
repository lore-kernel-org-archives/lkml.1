Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbXKIWu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbXKIWu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXKIWuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:50:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60016 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbXKIWuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:50:06 -0500
Subject: Re: kernel BUG message while using jffs2
From: David Woodhouse <dwmw2@infradead.org>
To: Alexandru Damian <ddalex@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f881070f0711090708u1b77a78dlcdb504a724b22fcf@mail.gmail.com>
References: <f881070f0711090708u1b77a78dlcdb504a724b22fcf@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 17:39:23 -0500
Message-Id: <1194647963.2588.41.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-09 at 17:08 +0200, Alexandru Damian wrote:
> Hello,
> 
> Sorry for posting here, it seems the best spot; if I need to redirect
> this to mtd-utils team, please tell me.
> 
> I'm playing around with some jffs2 files. While trying to mount (via
> block2mtd, loop) a jffs2 system, a "kernel BUG message" appeared in
> dmesg, with these lines:
> 
> kernel BUG at mm/slub.c:2204!

I don't see a BUG() or BUG_ON() anywhere near that line. What version of
the kernel? Precisely what is at that line?

-- 
dwmw2

