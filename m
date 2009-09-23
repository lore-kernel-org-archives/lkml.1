Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbZIWLUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbZIWLUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZIWLUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:20:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZIWLUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:20:34 -0400
Date: Wed, 23 Sep 2009 07:20:19 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Jamie Lokier <jamie@shareable.org>, Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "hch@infradead.org" <hch@infradead.org>
Subject: Re: fanotify as syscalls
Message-ID: <20090923112018.GA2946@infradead.org>
References: <20090912094110.GB24709@ioremap.net> <200909221731.34717.agruen@suse.de> <alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com> <200909230939.34003.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909230939.34003.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:39:33AM +0100, Tvrtko Ursulin wrote:
> Lived with it because there was no other option. We used LSM while it was 
> available for modules but then it was taken away. 
> 
> And not all vendors even use syscall interception, not even across platforms, 
> of which you sound so sure about. You can't even scan something which is not 
> in your namespace if you are at the syscall level. And you can't catch things 
> like kernel nfsd. No, syscall interception is not really appropriate at all.

The "Anti-Malware" industry is just snake oil anyway.  I think the
proper approach to support it is just to add various no-op exports claim
to do something and all the people requiring anti-virus on Linux will be
just as happy with it.

