Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZKWL6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZKWL6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbZKWL6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:58:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36833 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757077AbZKWL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:58:31 -0500
Date: Mon, 23 Nov 2009 11:59:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091123115949.29bcf89d@lxorguk.ukuu.org.uk>
In-Reply-To: <20091123114845.GC25575@elte.hu>
References: <20091121222319.GA3905@swanrl.gmail.com>
	<20091122063926.GA18224@elte.hu>
	<20091122122312.71a343d9@lxorguk.ukuu.org.uk>
	<1258952431.6261.38.camel@marge.simson.net>
	<20091123113110.15063a0a@lxorguk.ukuu.org.uk>
	<20091123114845.GC25575@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Another possibility is to do
> > 
> > 	if (tty->low_latency)
> > 		schedule_delayed_work(&tty->buf.work, 0);
> > 	else
> > 		schedule_delayed_work(&tty->buf.work, 1);
> 
> Flaggery for low latency is kind of lame though - especially if it 
> defaults to off in most drivers as you say.

So you'd prefer to detect devices that are byte based or message based by
what method ?

Alan
