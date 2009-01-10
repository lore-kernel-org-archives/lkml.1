Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZAJMzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZAJMzC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:55:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZAJMyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:54:50 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:60902 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZAJMyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:54:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ITFNggsove62oY2xqlI3Fy3PCtVKqNh33kojVtqftdfATwYScj0s1lariXb8AzLK7x
         YpPqDnNNyKs6oLP4kBC/YjKXQ411niXHi1b//B9KKKmc6AT7MUEj/kJw0v4GkRYArvEI
         gOQ1mEW9N3bm1SvW7CT7MOWzWiLN1ua6yzaJ4=
Date: Sat, 10 Jan 2009 15:54:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: James Chapman <jchapman@katalix.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, devel@openvz.org,
       xemul@openvz.org
Subject: Re: [RFC 3/4] net: pppol2tp - introduce net-namespace functionality
Message-ID: <20090110125444.GB29349@localhost>
References: <20090109195154.320495476@gmail.com>> <4967accc.0c58560a.2ee6.3de4@mx.google.com> <49688120.9000507@katalix.com> <20090110111359.GA29349@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110111359.GA29349@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Jan 10, 2009 at 02:13:59PM +0300]
| [James Chapman - Sat, Jan 10, 2009 at 11:06:08AM +0000]
| | Cyrill Gorcunov wrote:
| | > - Each tunnel and appropriate lock are inside own namespace now.
| | > - pppox code allows to create per-namespace sockets for
| | >   both PX_PROTO_OE and PX_PROTO_OL2TP protocols. Actually since
| | >   now pppox_create support net-namespaces new PPPo... protocols
| | >   (if they ever will be) should support net-namespace too otherwise
| | >   explicit check for &init_net would be needed.
| | > 
| | > CC: James Chapman <jchapman@katalix.com>
| | > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| | > ---
| | >  drivers/net/pppol2tp.c |  164 ++++++++++++++++++++++++++++++++++++-------------
| | >  drivers/net/pppox.c    |    4 -
| | >  2 files changed, 121 insertions(+), 47 deletions(-)
| | 
| | Looks ok from a pppol2tp point of view, though I'm not an expert on the
| | netns stuff.
| | 
| | The patches don't apply against latest net-next-2.6. If you respin the
| | patches, I'll test them for pppol2tp.
| | 
| | -- 
| | James Chapman
| | Katalix Systems Ltd
| | http://www.katalix.com
| | Catalysts for your Embedded Linux software development
| | 
| 
| Thanks James for taken look on. I'll check the latest net-next-2.6
| tree and update the patches soon. Thanks!
| 
| 		- Cyrill -

James I just fetched latest net-next-2.6 with
commit

---
commit 3c92ec8ae91ecf59d88c798301833d7cf83f2179
Merge: c4c9f01... ca9153a...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Dec 28 16:54:33 2008 -0800

    Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc
---

and patches are being applied on top without problems.
Maybe you have some other commits which are not propogated
to net-next-2.6 yet?

		- Cyrill -
