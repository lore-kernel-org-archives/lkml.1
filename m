Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYLCMq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYLCMq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYLCMqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:46:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49166 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753020AbYLCMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:46:40 -0500
Date: Wed, 3 Dec 2008 12:46:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Geoffrey McRae <geoff@rabidhost.com>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
Message-ID: <20081203124632.0ea40398@lxorguk.ukuu.org.uk>
In-Reply-To: <20081203124252.GD11807@mail.local.tull.net>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	<20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	<1228268657.6679.4.camel@lappy.spacevs.com>
	<20081203124252.GD11807@mail.local.tull.net>
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

> 300,000 processes each with a different uid. But if you had 300,000
> users and 200,000 different CGI scripts, you also have no choice but
> to fork and exec at request time, because there are too many different
> scripts.

You would normally maintain a pool then because you'd expect an uneven
loading and groups of requests to a given id. The number of scripts
shouldn't matter for a properly designed interpreter - you have a fastcgi
interpreter instance or similar which has the interpreter state ready and
just forks itself to handle the scripts (or does them threaded itself) for
that user.

Alan
