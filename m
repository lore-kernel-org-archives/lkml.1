Return-Path: <linux-kernel-owner+w=401wt.eu-S1765997AbZDBW74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765997AbZDBW74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762561AbZDBW7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:59:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764175AbZDBW7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:59:40 -0400
Date: Thu, 2 Apr 2009 15:51:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jeff@garzik.org, drees76@gmail.com, j@jannau.net,
       lsorense@csclub.uwaterloo.ca, tytso@mit.edu, jesper@krogh.cc,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-Id: <20090402155156.33d98b27.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu>
	<20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090326182519.d576d703.akpm@linux-foundation.org>
	<20090401210337.GB3797@csclub.uwaterloo.ca>
	<20090402110532.GA5132@aniel>
	<72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>
	<20090402094247.9d7ac19f.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0904020947310.4130@localhost.localdomain>
	<alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
	<49D53787.9060503@garzik.org>
	<alpine.LFD.2.00.0904021516540.4130@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 15:42:51 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> My only point is really that you _can_ do streaming writes well, but at 
> the same time I do think the kernel makes it too hard to do it with 
> "simple" applications. I'd love to get the same kind of high-speed 
> streaming behavior by just doing a simple "dd if=/dev/zero of=bigfile"
> 
> And I really think we should be able to.

The thing which has always worried me about trying to do smart
drop-behind is the cost of getting it wrong - and sometimes it _will_
get it wrong.

Someone out there will have an important application which linearly
writes a 1G file and then reads it all back in again.  They will get
really upset when their runtime doubles.
