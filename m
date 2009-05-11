Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZEKD7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZEKD7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZEKD7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:59:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:54644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbZEKD7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:59:05 -0400
Date: Sun, 10 May 2009 20:58:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090510205850.30d10fc2@infradead.org>
In-Reply-To: <20090510180018.260bc706.akpm@linux-foundation.org>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org>
	<20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de>
	<1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510180018.260bc706.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 18:00:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> A 1.5 second saving on some gadget which boots in 6 seconds would be a
> lot more interesting.

udev does not take 1.5 seconds today; it takes more like 0.75, of which
the last 2/3rds are optional/asynchronous.

Eric has shown that just making the nodes is 0.06 seconds with todays
sysfs interface, and there is room for improvement, and room for Kay
and Greg's patches if they get turned into having a nice flat ascii
file that lists all device nodes in the system. That way Kay and Greg
get the fast and easy startup of /dev that they want, and others like
Eric and me get the flexibility to have a slightly smarter program that
also gets the device ownership and permissions from a small database.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
