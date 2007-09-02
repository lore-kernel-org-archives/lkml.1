Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbXIBVT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbXIBVT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXIBVTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:19:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:12005 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbXIBVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=XhmKZqV84hIo7NQqFEjA3TzR2b+OLlYwRk7H4AjRNtjjz4bR7SqPiikSaaNGC5IRvhh/LRlu1wu7kABKGfF8ikzVTYmUXuMoIAD0di+FEdIpKI2/cTK9pPu+3FNFt6oPm7mpIu9xVVcrE43kcdUtSouaYWo3VVoAK/8uAwiH/Vc=
Date: Mon, 3 Sep 2007 01:19:07 +0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: 2.6.23-rc4-mm1: unpingable box and NULL dereference at tcp_rto_min()
Message-ID: <20070902211907.GA2452@martell.zuzino.mipt.ru>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070902023618.GA2537@martell.zuzino.mipt.ru> <20070902135245.aed7c7a9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902135245.aed7c7a9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 01:52:45PM -0700, Andrew Morton wrote:
> > On Sun, 2 Sep 2007 06:36:19 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > The bad news is something knocked off box from the net, then panicked it:
> 
> Yeah, the net tree has been quite bad lately.  Unusually bad - it's usually
> one of the good ones.
> 
> It also breaks a lot of the net driver work in several other trees (I dropped
> git-ixgbe.patch wholesale because of this).  But there isn't a lot we can
> do about that.  

OK, I'm currently running with "dst entry can be NULL" fix from net
tree, so far it's fine.
