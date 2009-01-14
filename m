Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZANKsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZANKsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZANKsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:48:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58367 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753283AbZANKsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:48:22 -0500
Date: Wed, 14 Jan 2009 10:48:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090114104834.18387fca@lxorguk.ukuu.org.uk>
In-Reply-To: <20090114104307.GA20451@elf.ucw.cz>
References: <20090114010223.GA21380@kroah.com>
	<20090114021801.GA14759@bulgaria.corp.google.com>
	<d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
	<20090114035237.GB16442@kroah.com>
	<20090114104307.GA20451@elf.ucw.cz>
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

> > Alan, does this sound like it should remain in the tree?
> 
> Maybe our oom killer should get a new tunable, telling it how
> aggressive it should be, instead?

I was thinking that, and it would integrate better with the OLPC work
(which IMHO is a nicer interface for some stuff)

You'd want two thresholds

The 'arghhhh....' point where you start killing stuff
The 'uh oh...' point where an OLPC style low memory notifier kicks in

(OLPC's model is a handle you can select/poll for 'memory getting low' so
apps can respond to pressure by doing stuff like dumping caches)

The rest ought to follow naturally IFF you can find a clean efficient way
to measure that pressure and quantify it as a number. Our default would
be like now, the Android default might be to trigger earlier..
