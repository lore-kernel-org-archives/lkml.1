Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0BCTxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:53:50 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:44628 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab0BCTxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:53:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m/rm14F6todlf/LGoB551zIKsLztEF2CHT2vQQAtgW7bTOM4K367u+fYsIPCXnzD3V
         cuukCzTu4GqhPHstJgqtdv9wJmPoTuyD/dfacntIck7HQQyodHgHwKCyLLisCdAwFfTX
         iDJX+kBfGjMGvi+z3QpnGu7HUOyo2vzS/NVtM=
Date: Wed, 3 Feb 2010 21:53:38 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
Message-ID: <20100203195338.GB5576@x200>
References: <4B685756.8010107@trash.net>
 <1265130426.2861.158.camel@tonnant>
 <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com>
 <1265134598.2861.191.camel@tonnant>
 <4B6870AF.6060109@trash.net>
 <4B6967BC.600@trash.net>
 <1265222289.2861.290.camel@tonnant>
 <20100203190948.GA5182@x200>
 <1265226227.2861.302.camel@tonnant>
 <1265226371.2861.303.camel@tonnant>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265226371.2861.303.camel@tonnant>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 02:46:11PM -0500, Jon Masters wrote:
> On Wed, 2010-02-03 at 14:44 -0500, Jon Masters wrote:
> > On Wed, 2010-02-03 at 21:09 +0200, Alexey Dobriyan wrote:
> > > On Wed, Feb 03, 2010 at 01:38:09PM -0500, Jon Masters wrote:
> 
> > > > I also think it is necessary to expose net namespace layout
> > > 
> > > Not necessary. Why?
> > 
> > How am I as a sysadmin supposed to figure out which net namespaces exist
> > on my system, and as a developer, supposed to debug these situations?
> 
> (without Jason's excellent kgdb patches, which really help)

Oh! Just like as usual, thinking and looking at oops and code.

Because when box is dead, netns info is not goint to be printed
anyway.
