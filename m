Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZEJVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZEJVTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZEJVTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:19:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37909 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752329AbZEJVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:19:07 -0400
Date: Sun, 10 May 2009 22:19:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
In-Reply-To: <1241980263.9562.380.camel@laptop>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org>
	<20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de>
	<1241980263.9562.380.camel@laptop>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /me boggles, however does one end up with that many partitions on so few
> disks? 

It happens. Tejun did the extending because libata users were really
hitting these limits.
 
> /boot
> /
> /home
> /usr
> swap
> /usr/local
> /opt
> 
> and I'm seriously out of sensible ideas.

I've seen two usual variants

	Fedora & Unbuntu & Debian & ....

	Fedora 10 & Rawhide & Fedora 9 & ...

for people who like to play with distros or need to test a product on them


and once you do that 16 is quite easy
