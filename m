Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZIWRbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZIWRbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZIWRbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:31:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59112 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZIWRbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:31:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 23 Sep 2009 10:31:26 -0700 (PDT)
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
In-Reply-To: <200909231645.29559.tvrtko.ursulin@sophos.com>
Message-ID: <alpine.DEB.2.00.0909231025120.22657@makko.or.mcafeemobile.com>
References: <20090912094110.GB24709@ioremap.net> <200909230939.34003.tvrtko.ursulin@sophos.com> <alpine.DEB.2.00.0909230755160.21515@makko.or.mcafeemobile.com> <200909231645.29559.tvrtko.ursulin@sophos.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, Tvrtko Ursulin wrote:

> Yeah, you could do something like kauth on OSX, which is I guess similar to 
> LSM, which was turned off for out of tree. And now you want to push users of 
> fanotify out of tree, so what should it be? In tree bad, out of tree bad? 

As I said before, the good of a syscall tracing approach, is that it is a 
completely generic mechanism (extensible for other kind of hooks too), 
with minimal kernel impact, while allowing its module-users to stuff all 
the code they want in the part that it's their responsibility.
So that a "we need this too" gets translated to "just do it in your code", 
instead of a request to add more stuff into the kernel, and maybe altering 
the userspace access interface (which is always painful).



- Davide


