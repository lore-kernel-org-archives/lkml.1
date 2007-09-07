Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbXIGPef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbXIGPef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbXIGPe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:34:26 -0400
Received: from mail.fieldses.org ([66.93.2.214]:35295 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089AbXIGPeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:34:25 -0400
Date: Fri, 7 Sep 2007 11:34:08 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Satyam Sharma <satyam@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
Message-ID: <20070907153408.GG24638@fieldses.org>
References: <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0709061355350.3781@enigma.security.iitk.ac.in> <20070906151118.GB28565@fieldses.org> <1189120910.6672.30.camel@heimdal.trondhjem.org> <1189121572.6672.36.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189121572.6672.36.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 01:32:52AM +0200, Trond Myklebust wrote:
> Sorry. Of course, you have to copy the entire /lib, etc. onto the tmpfs,
> but you get the gist....
> 
> The point is that it is easy to subvert userspace if you have enough
> privileges. In the above example it may not be entirely undetectable,
> but who here is running a script on every login to check that / is
> indeed uncompromised?

I suppose this is the motivation for things like the "secure attention
key"?

But I'm most curious actually about to what degree the kernel itself is
vulnerable to root (without a reboot).  Is disabling /dev/kmem and
module-loading in theory enough?  (Modulo bugs like filesystems that
aren't secure against untrusted filesystems, etc.)

--b.
