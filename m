Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbYFRCgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbYFRCgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 22:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbYFRCgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 22:36:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46976 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759592AbYFRCgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 22:36:06 -0400
Date: Wed, 18 Jun 2008 12:21:15 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
	bisected, reproducable)
Message-ID: <20080618022115.GA1383@brong.net>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 10:08:24AM -0700, Linus Torvalds wrote:
> On Tue, 17 Jun 2008, Bron Gondwana wrote:
> > 
> > And I appear to have sent the one without the usage comments at the top.
> > Here they are:
> 
> Very interesting. There's certainly something there. 
> 
> That said, there's a distracting bug which is visible when doing an strace
> 
>  lseek(4, 140333890921392, SEEK_SET)     = -1 EINVAL (Invalid argument)
>  write(4, "\0\0\0\0", 4)                 = 4

Bah - crap.  Sorry about that.  I sent you the wrong version of the
code.  That's what I get for not putting it in revision control.

That bug exists because I did an htonl on a value that I shouldn't
have.

Bron ( now to read the rest of the thread! )
