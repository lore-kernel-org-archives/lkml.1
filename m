Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbZDCIff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbZDCIff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZDCIfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:35:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34693 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZDCIfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:35:16 -0400
Message-ID: <49D5CA3E.6020400@garzik.org>
Date: Fri, 03 Apr 2009 04:35:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D53787.9060503@garzik.org> <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain> <49D56DF6.5020300@garzik.org> <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain> <49D5C972.8000903@garzik.org>
In-Reply-To: <49D5C972.8000903@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Attached are some additional tests using sync_file_range, dd, an SSD and 
> a normal SATA disk.  The test program -- overwrite.c -- is unchanged 
> from my last posting, basically the same as Linus's except with 
> posix_fadvise()

Oh, and, as run-test.sh shows, these tests were done with the file 
pre-allocated and sync'd to disk.

The dd and overwrite invocations that follow the first dd invocation do 
/not/ require the fs to allocate new blocks.

	Jeff



