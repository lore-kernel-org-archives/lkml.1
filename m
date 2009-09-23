Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbZIWP0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbZIWP0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZIWP0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:26:52 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43063 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZIWP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:26:51 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 23 Sep 2009 08:26:49 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
cc: Andreas Gruenbacher <agruen@suse.de>, Jamie Lokier <jamie@shareable.org>,
       Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "hch@infradead.org" <hch@infradead.org>
Subject: Re: fanotify as syscalls
In-Reply-To: <200909230939.34003.tvrtko.ursulin@sophos.com>
Message-ID: <alpine.DEB.2.00.0909230755160.21515@makko.or.mcafeemobile.com>
References: <20090912094110.GB24709@ioremap.net> <200909221731.34717.agruen@suse.de> <alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com> <200909230939.34003.tvrtko.ursulin@sophos.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, Tvrtko Ursulin wrote:

> Lived with it because there was no other option. We used LSM while it was 
> available for modules but then it was taken away. 
> 
> And not all vendors even use syscall interception, not even across platforms, 
> of which you sound so sure about. You can't even scan something which is not 
> in your namespace if you are at the syscall level. And you can't catch things 
> like kernel nfsd. No, syscall interception is not really appropriate at all.

Really?
And *if* namespaces were the problem for the devices you were targeting, 
what prevented you to resolving the object and offering a stream to 
userspace?
In *your* module, hosting at the same time all the other logic required 
for it (caches, whitelists, etc...), instead of pushing this stuff into 
the kernel.
WRT to the "other" system, never said they were using syscall 
interception, if you read carefully. I said that minifilters typically 
sends path names to userspace, which might drive you in the pitfall 
Andreas was describing.


- Davide


