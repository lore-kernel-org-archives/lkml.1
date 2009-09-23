Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbZIWPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbZIWPf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZIWPf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:35:26 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33236 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZIWPfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:35:25 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 23 Sep 2009 08:35:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "hch@infradead.org" <hch@infradead.org>
cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Jamie Lokier <jamie@shareable.org>, Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: fanotify as syscalls
In-Reply-To: <20090923112018.GA2946@infradead.org>
Message-ID: <alpine.DEB.2.00.0909230827100.21515@makko.or.mcafeemobile.com>
References: <20090912094110.GB24709@ioremap.net> <200909221731.34717.agruen@suse.de> <alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com> <200909230939.34003.tvrtko.ursulin@sophos.com> <20090923112018.GA2946@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009, hch@infradead.org wrote:

> On Wed, Sep 23, 2009 at 09:39:33AM +0100, Tvrtko Ursulin wrote:
> > Lived with it because there was no other option. We used LSM while it was 
> > available for modules but then it was taken away. 
> > 
> > And not all vendors even use syscall interception, not even across platforms, 
> > of which you sound so sure about. You can't even scan something which is not 
> > in your namespace if you are at the syscall level. And you can't catch things 
> > like kernel nfsd. No, syscall interception is not really appropriate at all.
> 
> The "Anti-Malware" industry is just snake oil anyway.  I think the
> proper approach to support it is just to add various no-op exports claim
> to do something and all the people requiring anti-virus on Linux will be
> just as happy with it.

The fear is that this becomes a trojan horse (no pun intended) for more 
and more hooks and "stuff", driven by we-really-need-this-too and 
we-really-need-that-too. And once something it's in, it's harder to say no, 
under the pressure of offering a "limited solution".
This ws the reason I threw the syscall tracing thing in, so they have a 
low level generic hook, and they cam knock themselves out in their module 
(might need a few exports, but that's about it).



- Davide


