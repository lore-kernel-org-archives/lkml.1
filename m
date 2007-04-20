Return-Path: <linux-kernel-owner+w=401wt.eu-S1766796AbXDTI6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766796AbXDTI6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766692AbXDTI6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:58:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1766516AbXDTI6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:58:35 -0400
Date: Fri, 20 Apr 2007 01:58:38 -0700 (PDT)
Message-Id: <20070420.015838.83621529.davem@davemloft.net>
To: dhowells@redhat.com
Cc: ebiederm@xmission.com, akpm@osdl.org, containers@lists.osdl.org,
       oleg@tv-sign.ru, hch@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Getting the new RxRPC patches upstream 
From: David Miller <davem@davemloft.net>
In-Reply-To: <1101.1177056127@redhat.com>
References: <29341.1176975158@redhat.com>
	<2969.1176992303@redhat.com>
	<1101.1177056127@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 20 Apr 2007 09:02:07 +0100

> David Miller <davem@davemloft.net> wrote:
> 
> > I applied already the patches I thought were appropriate,
> > you had some crypto layer changes that you need to work
> > out with Herbert Xu before the rest can be applied.
> 
> Should the rest of it go via Andrew's tree then?

Now that Herbert cleared up the crypto layer issues
the only problem left is that there are generic changes
in there which are not strictly networking but which
your subsequent networking changes depend upon.

This is a mess, and makes merging your work into the
net-2.6.22 tree more difficult.

Is it possible for your changes to be purely networking
and not need those changes outside of the networking?

I guess one of them was just a symbol export which I
could add to the net-2.6.22 tree, but weren't there some
more involved non-networking bits in there?
