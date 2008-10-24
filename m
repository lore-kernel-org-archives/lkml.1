Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYJXI6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYJXI6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 04:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYJXI6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:58:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42582 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778AbYJXI6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:58:38 -0400
Date: Fri, 24 Oct 2008 09:57:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] n-tty-fix-cont-and-ctrl-output
Message-ID: <20081024095758.4b3696d0@lxorguk.ukuu.org.uk>
In-Reply-To: <48FFD4A8.7050109@skyrush.com>
References: <48F2E450.1070508@skyrush.com>
	<20081022103259.2d04729a@lxorguk.ukuu.org.uk>
	<48FFD4A8.7050109@skyrush.com>
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

On Wed, 22 Oct 2008 19:34:32 -0600
Joe Peterson <joe@skyrush.com> wrote:

> Fix process_output_block to detect continuation characters correctly
> and to handle control characters even when O_OLCUC is enabled.  Make
> similar change to do_output_char().

If I have a upper case character as my control code then OLCUC should
upper case the printed result..
