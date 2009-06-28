Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZF1AFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZF1AFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 20:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZF1AFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 20:05:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:51796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZF1AFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 20:05:04 -0400
Date: Sat, 27 Jun 2009 17:06:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arno Schuring <aelschuring@hotmail.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: 2.6.31-rc1 WARNING: at drivers/char/tty_ldisc.c:210
Message-ID: <20090627170609.4ff42e69@infradead.org>
In-Reply-To: <4A469C4A.5050309@hotmail.com>
References: <4A469C4A.5050309@hotmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 00:25:14 +0200
Arno Schuring <aelschuring@hotmail.com> wrote:

> Hello to all,
> 
> Current 2.6.31-rc1 is triggering a warning on my machine (x86
> non-smp). I can reliably trigger this warning by booting single-user
> and performing telinit 2 (which continues normal boot). I'm testing
> with Radeon kernel modesetting enabled on an R300 card, but I'm not
> sure if that is relevant.
> 
> First of all: if I'm posting to the wrong list, please kindly redirect
> me to the correct location. I have found one reference to this
> warning, it was on the PPC list:
> http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg34679.html
> 


you're not the first one to hit this one, yet it's a pretty rare thing
to happen as well:

http://www.kerneloops.org/search.php?search=tty_ldisc_put

more common things have hundreds if not thousands of entries in the
kerneloops database..


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
