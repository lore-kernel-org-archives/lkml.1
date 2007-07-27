Return-Path: <linux-kernel-owner+w=401wt.eu-S938145AbXG0WIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938145AbXG0WIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765708AbXG0WIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:08:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39068 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761697AbXG0WIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:08:12 -0400
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources
	 (was: updatedb)
From: Arjan van de Ven <arjan@infradead.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
In-Reply-To: <52449.81.207.0.53.1185573103.squirrel@secure.samage.net>
References: <200707272243.02336.a1426z@gawab.com>
	 <1185568498.2711.5.camel@laptopd505.fenrus.org>
	 <52449.81.207.0.53.1185573103.squirrel@secure.samage.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 27 Jul 2007 15:06:14 -0700
Message-Id: <1185573974.2711.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 23:51 +0200, Indan Zupanci
> > also, they take up seek time (5 to 10 msec), so if you were to read
> > something else at the time you get additional latency.
> 
> If there's other disk activity swap prefetch shouldn't do much, so this isn't
> really true.

how do you know there will be other activity? You start the IO and that
basically blacks out the disk for 5 to 10 ms. If the "real" IO gets
submitted in that time you add latency. You cannot predict that IO
happening or not happening.


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

