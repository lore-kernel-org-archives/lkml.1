Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYGNOaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYGNOaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYGNOaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:30:04 -0400
Received: from general-ld-225.t-mobile.co.uk ([149.254.200.225]:46151 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753466AbYGNOaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:30:03 -0400
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 10:30:02 EDT
Date: Mon, 14 Jul 2008 14:33:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Michael H. Warfield" <mhw@wittsend.com>
Subject: Re: [PATCH] ip2: avoid add_timer() with pending timer
Message-ID: <20080714143357.2d6cfc91@the-village.bc.nu>
In-Reply-To: <20080714024955.GB30952@sssvn.sssvn>
References: <20080714024955.GB30952@sssvn.sssvn>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 11:49:55 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> add_timer() is not suppose to be called when the timer is pending.
> ip2 driver attempts to avoid that condition by setting and resetting
> a flag (TimerOn) in timer function. But there is some gap between
> add_timer() and setting TimerOn.
> 
> This patch fix this problem by using mod_timer() and remove TimerOn
> which has been unnecessary by this change.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Michael H. Warfield <mhw@wittsend.com>

Acked-by: Alan Cox <alan@redhat.com>

Queued for ttydev tree

Alan
