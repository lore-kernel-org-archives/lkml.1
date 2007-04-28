Return-Path: <linux-kernel-owner+w=401wt.eu-S1163420AbXD1SL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163420AbXD1SL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163430AbXD1SL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:11:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53081 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163425AbXD1SLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:11:53 -0400
Message-ID: <46338E61.1080708@garzik.org>
Date: Sat, 28 Apr 2007 14:11:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
References: <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com> <20070427221803.2a117c23.akpm@linux-foundation.org> <p73tzv022qw.fsf@bingen.suse.de> <20070428030213.4787031f.akpm@linux-foundation.org> <20070428170644.GB20646@redhat.com>
In-Reply-To: <20070428170644.GB20646@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Sat, Apr 28, 2007 at 03:02:13AM -0700, Andrew Morton wrote:
> 
>  > This little checking tool should have both "error" and "warning" levels -
>  > AKA "fix this" and "think about this" levels.  BUG_ON would be a warning
>  > thing.
> 
> There's a -pedantic option there just for this.  I'll move BUG_ON under it.
> What's the consensus on the u32 thing, move that too, or drop completely?

Not answering your question directly, but FWIW:  In day to day coding 
and email, I strongly advocate the use of u8/u16/u32 over the C99 
size-based types.

Simple, direct (read: easiest to review), and less typing.

	Jeff


