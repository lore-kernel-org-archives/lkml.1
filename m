Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZDFXTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZDFXTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZDFXTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:19:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34583 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbZDFXTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:19:38 -0400
Date: Tue, 7 Apr 2009 00:19:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Hua Zhong <hzhong@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090407001955.0bf73f72@lxorguk.ukuu.org.uk>
In-Reply-To: <2c0942db0904061548x2d34eff7g9b5332826509da53@mail.gmail.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
	<20090406151054.GD5178@kernel.dk>
	<alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
	<20090406183157.GD7376@mit.edu>
	<alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
	<002501c9b6f3$f85b4910$e911db30$@com>
	<20090406211931.GB8586@mit.edu>
	<003001c9b6ff$a9259ce0$fb70d6a0$@com>
	<2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
	<003401c9b706$9c4c1b50$d4e451f0$@com>
	<2c0942db0904061548x2d34eff7g9b5332826509da53@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> apparently it never was unless you specifically mounted your ext3
> filesystem with data=ordered. The default was only that, a default,
> and one that can still be specified explicitly.

Look up "principle of least suprise"

> There are an unbounded number of possible incorrect setups in the
> world. Should we live in fear of their existence without any proof?

No but creating new ones for users is not good.

> I accept Linus' argument that the change in crash behavior for random
> folk is going to be very different, and that perhaps that alone should
> drive keeping the default as it is today, but now we're talking about
> the desktop space.

Which regularly handles data of great value -- like PhD theses.

Ext4 provides a good natural migration point, ext3 mid series does not.
