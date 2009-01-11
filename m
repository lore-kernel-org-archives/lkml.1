Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZAKIZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZAKIZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 03:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZAKIZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 03:25:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:53909 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZAKIZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 03:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K/tu1y63Zgz3TOyfEpCsu16lkLkDyD6jHUBo1SaESMYiJzxu6PLRiO6JT1lt5zox60
         sQJ3l1oeJ/Q1SwRyOeQJjg9gF2bi9xpr7fCAi9DPiCKV1G8UoKFUzN+e/Lxaww+kVaBr
         XQ+RqBaqbqghi24S0O28IdFc5qVbLlH5oSBCk=
Date: Sun, 11 Jan 2009 11:25:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paul Mackerras <paulus@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, devel@openvz.org,
       xemul@openvz.org
Cc: James Chapman <jchapman@katalix.com>
Subject: Re: [RFC 4/4] net: ppp_generic - introduce net-namespace
	functionality
Message-ID: <20090111082522.GC7686@localhost>
References: <20090109195154.320495476@gmail.com> <4967accd.0305560a.3553.ffffd187@mx.google.com> <20090110092258.GA7622@localhost> <20090110092830.GB7622@localhost> <18793.15953.591733.958862@cargo.ozlabs.ibm.com> <20090111074652.GB7686@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111074652.GB7686@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Jan 11, 2009 at 10:46:52AM +0300]
| [Paul Mackerras - Sun, Jan 11, 2009 at 11:33:21AM +1100]
| | Cyrill Gorcunov writes:
| | 
| | > From: Cyrill Gorcunov <gorcunov@gmail.com>
| | > Subecjt: [RFC] net: ppp_generic - introduce net-namespace functionality
| | > 
| | > - Each namespace contain ppp channels and units separately
| | >   with appropriate locks
| | 
| | This looks like a lot of uglification to me.  Why exactly do
| | individual network drivers need to know or care about namespaces?
| | 
| | Paul.
| | 
| 
| Unfortunately in the whole series ppp has been change more
| then others and it's looks ugly indeed that is why it was RFC.
| Namespaces imply isolation of data right? Including private
| data being 'user related' -- ie units passed to user in one
| namespace should not interfere with units passed to user in
| another namespace. So if I will not 'bind' units pool to
| namespaces it would be possible to steal unit from one namespace
| proposed for another namespace. Right?
| 
| 		- Cyrill -

Anyway, thanks for review -- I'll check if I could make this
series less 'ugly'. I just wanna hear what people think about
this series 'in general' (or maybe even test it [James, thanks!] :) --
since the series is RFC and not to include in any kind of tree.

		- Cyrill -
