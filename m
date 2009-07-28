Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbZG1TIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbZG1TIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZG1TIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:08:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49563 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751320AbZG1TIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:08:30 -0400
Date: Tue, 28 Jul 2009 20:07:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zamsden@redhat.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
Message-ID: <20090728200726.08baadca@lxorguk.ukuu.org.uk>
In-Reply-To: <f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com>
References: <4A6D79F6.3050509@redhat.com>
	<1248699365.6987.1628.camel@twins>
	<20090727142536.465799aa@lxorguk.ukuu.org.uk>
	<4A6E529B.9030104@kernel.org>
	<4A6E764E.80805@redhat.com>
	<20090728112734.5a75752d@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907280851360.3186@localhost.localdomain>
	<f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's not so much an argument against LVM as it is an argument for
> fixing those distro installer tools...  Using device-mapper to map
> standard Linux partition-tables has the following benefits:

I'll add another one: If your disk blows up when you touch sector 0 you
can rescue it in Linux without hacking the kernel.

It doesn't mean you have to ditch partition processing out of the kernel,
merely to be able to turn it off for some devices. Actually removing it
would never be practical.




