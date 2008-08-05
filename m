Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbYHELtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbYHELtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbYHELtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:49:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49906 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755757AbYHELtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:49:42 -0400
Date: Tue, 5 Aug 2008 12:31:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Greg KH <greg@kroah.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for
 on access scanning
Message-ID: <20080805123136.0073e52f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805005415.GA10108@infradead.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<20080805002618.GA18215@infradead.org>
	<1217897224.27684.66.camel@localhost.localdomain>
	<20080805005415.GA10108@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, I want a sane security policy in kernelsapce that doesn't look
> at the content because doing security by content properly is equivalent
> to solving the halting problem.  I couldn't give a rats a** about
> windows viruses as they can't actually cause any harm on a Linux
> machine.

Go on then.. post patches.

I think your are being incredibly naïve. Our memory debugging is not 100%
solid but work by heuristic. Our lock analysis doesn't solve the halting
problem but is extremely useful and so on.

> Well, data can change all the time, as can the path name.  This whole
> content scanning thing doesn't make any sense at all.

Phone numbers change all the time, shall we burn all the phone books ?

> So make this opt-in and in userspace.  Just LD_PRELOAD some monster lib
> doing all the horrible things you propose and use it wherever you want.

Rather tricky as the needed hooks don't exist and you need to get ahead
of even ld.so as well as protect suid apps. You've clearly not even
thought about the problem space before sounding off because there are
more elegant ways of tackling it even if you want to push it at
userspace, and ones that aren't implausible like LD_PRELOAD.

If you'd applied even 30 seconds thought you would at least be pointing
people at FUSE or a stacking fs.

Alan
