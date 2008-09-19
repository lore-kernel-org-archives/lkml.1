Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYISOzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYISOzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYISOzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:55:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752723AbYISOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:55:39 -0400
Date: Fri, 19 Sep 2008 15:51:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Anti Sullin <anti.sullin@artecdesign.ee>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91 Serial: update the powersave handler to match
 serial core
Message-ID: <20080919155109.32dc282d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080919161625.360e514d@hskinnemo-gx745.norway.atmel.com>
References: <48CE42C8.1090608@artecdesign.ee>
	<20080919150938.08b2c7be@hskinnemo-gx745.norway.atmel.com>
	<48D3AE78.207@artecdesign.ee>
	<20080919161625.360e514d@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe the tty layer ensures that the buffer is empty before
> suspending...would be interesting to know. In any case, any such bug

It doesn't - but calling tty_wait_until_sent(tty, some_timeout) will do
that for you providing you call it in a sleep capable context.

Alan
