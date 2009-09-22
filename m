Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbZIVQ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbZIVQ1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZIVQ13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:27:29 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47509 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZIVQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:27:28 -0400
Date: Tue, 22 Sep 2009 17:27:07 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Eric Paris <eparis@redhat.com>
Cc: Andreas Gruenbacher <agruen@suse.de>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, alan@linux.intel.com, hch@infradead.org
Subject: Re: fanotify as syscalls
Message-ID: <20090922162707.GA11608@shareable.org>
References: <20090912094110.GB24709@ioremap.net> <20090921231227.GJ14700@shareable.org> <alpine.DEB.2.00.0909211816020.1116@makko.or.mcafeemobile.com> <200909221731.34717.agruen@suse.de> <1253635918.2747.5.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253635918.2747.5.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> That's not the fatal flaw.  The fatal flaw is that I am not going to
> write 90% of a rootkit and make it easy to use.

I hate to point out the obvious, but fanotify's ability to intercept
every file access and rewrite the file before the access proceeds is
also 90% of a rootkit...

But fortunately both fanotify and syscall rewriting require root in
the first place.

I think that makes the rootkit argument moot.  As long as fanotify
doesn't have a non-root flavour... which really would be handy for
rootkits :-)

> Easy != Good.

I agree.

-- Jamie
