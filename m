Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbYLCK3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbYLCK3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYLCK30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:29:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59133 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbYLCK3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:29:25 -0500
Date: Wed, 3 Dec 2008 10:29:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geoffrey McRae <geoff@rabidhost.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
Message-ID: <20081203102925.1aa97d14@lxorguk.ukuu.org.uk>
In-Reply-To: <1228268657.6679.4.camel@lappy.spacevs.com>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	<20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	<1228268657.6679.4.camel@lappy.spacevs.com>
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

> The idea is to not allow the child to change its own uid, or give the
> child any elevated privlages so that should the child be compromised via
> buffer overflow or some other bug, it cant be abused.

But the child process can modify itself, it can open files etc.

So as uid 1 I patch my own code to add a function call to a private
function that will be called regularly. Now as the other uids are
selected I am able to attack all those users file stores.

I don't think your model actually works.
