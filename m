Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZFVN7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZFVN7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFVN7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:59:03 -0400
Received: from [212.98.175.89] ([212.98.175.89]:47237 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751551AbZFVN7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:59:02 -0400
Date: Mon, 22 Jun 2009 16:59:35 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Message-ID: <20090622135935.GB32155@localdomain.by>
References: <20090619181529.GA3593@localdomain.by>
 <20090620174320.GA6791@debian>
 <20090620185452.GD3138@localdomain.by>
 <20090622105721.262179f9@lxorguk.ukuu.org.uk>
 <20090622113308.GA32155@localdomain.by>
 <20090622133612.22fd84b8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622133612.22fd84b8@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/22/09 13:36), Alan Cox wrote:
> Just delete the tty_unthrottle() from drivers/net/ppp/ppp_async.c - it
> never throttles the port so it never needs to unthrottle it 

Right. Thanks.
Will test.

>
>(which is why it happened never to cause crashes before)
> 

	Sergey
