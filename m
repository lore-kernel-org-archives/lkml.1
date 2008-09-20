Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYITOfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYITOfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYITOfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:35:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128AbYITOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:35:00 -0400
Date: Sat, 20 Sep 2008 15:34:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Pellegrin <chripell@gmail.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Christian Pellegrin <chripell@fsfe.org>
Subject: Re: [PATCH] max3100 driver
Message-ID: <20080920153412.15e26a93@lxorguk.ukuu.org.uk>
In-Reply-To: <20080920065652.11d76780@infradead.org>
References: <1221895208650-git-send-email-chripell@gmail.com>
	<20080920012454.e40f03cc.akpm@linux-foundation.org>
	<20080920065652.11d76780@infradead.org>
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

> I do have a question though: what does a signed bitfield of 1 mean?
> I mean.. the variables are "int", so signed.... where will the compiler
> store the sign bit???

It sign extends so you get 0 or -1. Yes it would be good to use unsigned
to avoid suprises.
