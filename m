Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbXIJRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbXIJRz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXIJRzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:55:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbXIJRzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:55:13 -0400
Date: Mon, 10 Sep 2007 10:54:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-Id: <20070910105410.25e1d54c.akpm@linux-foundation.org>
In-Reply-To: <20070910184454.6c2a8ab9@the-village.bc.nu>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
	<20070909145940.0b41c8a5.akpm@linux-foundation.org>
	<20070910090808.GA31204@infradead.org>
	<20070910022324.c69e1897.akpm@linux-foundation.org>
	<20070910124358.GB21089@ftp.linux.org.uk>
	<20070910102556.de35e825.akpm@linux-foundation.org>
	<20070910184454.6c2a8ab9@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 18:44:54 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > A single kernel release seems sufficient.  It gives the maintainers of such
> > code time to hear about the breakage and time to fix it.
> 
> Users don't report warnings generally. They won't even see modprobe
> warnings or anything in dmesg. Short of using their sound card to scream
> "Next release you are screwed" they won't notice (and if you the sound
> card trick they'll think they got rooted....)
> 

I once made the mistake of putting a "please tell andrewm@uow.edu.au" printk
in 3c59x.c.  My inbox nearly died.  Then there's that damned "PCI bus hidden
behind transparent bus" printk which I've actually removed from -mm because
so many people keep reporting it and we don't do anything about it.

All it takes is a couple of people to report the problem to the maintainer
over a few-weeks period.  It doesn't seem unreasonable to expect this to
happen.
