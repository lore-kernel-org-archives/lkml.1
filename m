Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZBAWkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZBAWkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 17:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZBAWjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 17:39:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58792 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752478AbZBAWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 17:39:52 -0500
Date: Sun, 1 Feb 2009 23:09:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] TTY: tty_io, lookup retval fixup
Message-ID: <20090201230931.6f154044@the-village.bc.nu>
In-Reply-To: <1233524356-10994-1-git-send-email-jirislaby@gmail.com>
References: <1233524356-10994-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Feb 2009 22:39:16 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> Make sure we fail on NULL return value possibly returned by pty
> master lookup.
> 
> Convert NULL to ERR_PTR(-ENODEV), since NULL is not captured by
> IS_ERR() in __tty_open.

Better to fix any broken functions I think
