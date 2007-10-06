Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbXJFJvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbXJFJvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 05:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXJFJvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 05:51:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53546 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753990AbXJFJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 05:51:09 -0400
Date: Sat, 6 Oct 2007 10:55:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [PATCH] vc bell config
Message-ID: <20071006105536.1a237390@the-village.bc.nu>
In-Reply-To: <20071005170011.b4d280bf.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
	<20071005170011.b4d280bf.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007 17:00:11 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 5 Oct 2007 13:55:52 +0200 (CEST)
> Jan Engelhardt <jengelh@computergmbh.de> wrote:
> 
> > 
> > It is already possible to deactivate the vc bell on a per-tty basis,
> > by using echo -en "\e[11;0]", but this is reset on reset(1).
> > 
> > This adds a sysfs parameter to globally control the vc bell, as well
> > as sysfs parameters for default pitch and duration.
> > 
> 
> Why do we need this?  To fix the stupid-app-makes-my-box-beep problem, I
> guess.  Is there no other way of suppressing the beep? (no jokes about wire
> cutters or earplugs, please).

man setterm

See -blength and -bfreq

Alan
