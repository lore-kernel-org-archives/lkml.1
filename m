Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbYGKPFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbYGKPFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYGKPFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:05:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36779 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752131AbYGKPFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:05:38 -0400
Date: Fri, 11 Jul 2008 15:47:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Elias Oltmanns <eo@nebensachen.de>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
Message-ID: <20080711154748.407ea6c9@lxorguk.ukuu.org.uk>
In-Reply-To: <486E9366.2090901@skyrush.com>
References: <48661488.10304@gmail.com>
	<87fxqurqpz.fsf@denkblock.local>
	<486E83C3.1040509@skyrush.com>
	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
	<486E9366.2090901@skyrush.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> seems that the following two calls do the same thing in n_tty.c:
> 
> 		n_tty_flush_buffer(tty);
> 		tty_driver_flush_buffer(tty);

Sorry missed this originally - they don't do the same thing. The first
clears out anything in the ldisc internally the second clears out
anything in the tty driver itself.
