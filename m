Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZBJCmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZBJCmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 21:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbZBJCl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 21:41:59 -0500
Received: from vena.lwn.net ([206.168.112.25]:56643 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZBJCl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 21:41:59 -0500
Date: Mon, 9 Feb 2009 19:41:56 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 3/4] Move FASYNC bit handling to f_op->fasync()
Message-ID: <20090209194156.1f6a60b0@bike.lwn.net>
In-Reply-To: <20090208090550.GC18521@lst.de>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net>
	<1234037217-16124-4-git-send-email-corbet@lwn.net>
	<20090208090550.GC18521@lst.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009 10:05:50 +0100
Christoph Hellwig <hch@lst.de> wrote:

> > +	/* Maintaining the FASYNC bit is our job now */  
> 
> Not sure this comment is a good idea.  All comments of the style
> something has changes and is this now get stale really soon.  If you
> want to document that change in more details it should probably go
> into Documentation/filesystems/Locking near the fasync part.

Good point.  I've removed the comment and updated the doc file instead.

Thanks,

jon
