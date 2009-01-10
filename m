Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZAJLOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZAJLOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZAJLOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:14:06 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:39600 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZAJLOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vXICao8rs/9oBAwBNruD4zFfWK2aiDWk+EPTOw7oXCCx7/e4QEXDe2MAD9t+i/e8LJ
         fuaEfqHmEVXnUNF1N70Hy7G/5YG4nHkFC3LhXsr5J5B+zW5GQla4hkziDmBHH6X0zuBm
         +A3Q8s/uFq+rfinERCEnz97MifBGHw6GslqcE=
Date: Sat, 10 Jan 2009 14:13:59 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: James Chapman <jchapman@katalix.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org
Subject: Re: [RFC 3/4] net: pppol2tp - introduce net-namespace functionality
Message-ID: <20090110111359.GA29349@localhost>
References: <20090109195154.320495476@gmail.com>> <4967accc.0c58560a.2ee6.3de4@mx.google.com> <49688120.9000507@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49688120.9000507@katalix.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[James Chapman - Sat, Jan 10, 2009 at 11:06:08AM +0000]
| Cyrill Gorcunov wrote:
| > - Each tunnel and appropriate lock are inside own namespace now.
| > - pppox code allows to create per-namespace sockets for
| >   both PX_PROTO_OE and PX_PROTO_OL2TP protocols. Actually since
| >   now pppox_create support net-namespaces new PPPo... protocols
| >   (if they ever will be) should support net-namespace too otherwise
| >   explicit check for &init_net would be needed.
| > 
| > CC: James Chapman <jchapman@katalix.com>
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > ---
| >  drivers/net/pppol2tp.c |  164 ++++++++++++++++++++++++++++++++++++-------------
| >  drivers/net/pppox.c    |    4 -
| >  2 files changed, 121 insertions(+), 47 deletions(-)
| 
| Looks ok from a pppol2tp point of view, though I'm not an expert on the
| netns stuff.
| 
| The patches don't apply against latest net-next-2.6. If you respin the
| patches, I'll test them for pppol2tp.
| 
| -- 
| James Chapman
| Katalix Systems Ltd
| http://www.katalix.com
| Catalysts for your Embedded Linux software development
| 

Thanks James for taken look on. I'll check the latest net-next-2.6
tree and update the patches soon. Thanks!

		- Cyrill -
