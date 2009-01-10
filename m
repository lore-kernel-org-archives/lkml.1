Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZAJLOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZAJLOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZAJLOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:14:16 -0500
Received: from katalix.com ([82.103.140.233]:59016 "EHLO mail.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbZAJLOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:14:15 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jan 2009 06:14:15 EST
Message-ID: <49688120.9000507@katalix.com>
Date: Sat, 10 Jan 2009 11:06:08 +0000
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [RFC 3/4] net: pppol2tp - introduce net-namespace functionality
References: <20090109195154.320495476@gmail.com>> <4967accc.0c58560a.2ee6.3de4@mx.google.com>
In-Reply-To: <4967accc.0c58560a.2ee6.3de4@mx.google.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> - Each tunnel and appropriate lock are inside own namespace now.
> - pppox code allows to create per-namespace sockets for
>   both PX_PROTO_OE and PX_PROTO_OL2TP protocols. Actually since
>   now pppox_create support net-namespaces new PPPo... protocols
>   (if they ever will be) should support net-namespace too otherwise
>   explicit check for &init_net would be needed.
> 
> CC: James Chapman <jchapman@katalix.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  drivers/net/pppol2tp.c |  164 ++++++++++++++++++++++++++++++++++++-------------
>  drivers/net/pppox.c    |    4 -
>  2 files changed, 121 insertions(+), 47 deletions(-)

Looks ok from a pppol2tp point of view, though I'm not an expert on the
netns stuff.

The patches don't apply against latest net-next-2.6. If you respin the
patches, I'll test them for pppol2tp.

-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

