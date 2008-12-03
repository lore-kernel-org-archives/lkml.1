Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYLCPf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYLCPf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYLCPfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:35:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51098 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753195AbYLCPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:35:45 -0500
Date: Wed, 3 Dec 2008 15:35:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 1/1 #2] Char: n_tty, include module.h
Message-ID: <20081203153537.4504bdd7@lxorguk.ukuu.org.uk>
In-Reply-To: <1228317711-1311-1-git-send-email-jirislaby@gmail.com>
References: <1228317711-1311-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Dec 2008 16:21:51 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> this is a ldisc-n_tty-export-all-n_tty-ldisc-methods.patch fix.

NAK and NAK the patch needing it.

Once PPS is in this can be revisted by adding the almost identical N_PPS
ldisc into n_tty with a couple of different handlers (notably some of the
termios flags need to be handled differently)
