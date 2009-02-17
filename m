Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZBQJwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZBQJwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZBQJwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:52:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:29180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZBQJwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-mutt-references
         :x-mutt-fcc:user-agent;
        b=xJT8wT2bKUClI2HJtR2bTSxFE0WZUUzvYcyLLieyF13GgYjIb17QcLYoVk78x8n3me
         azmDpMgMz4AjSi6D4jtpbzru2NB4W0Xn9r8/OR/6CIoRtyVaI+TpQFE0cZoEvkPk+6i3
         eSFOqPczLiks5/wjq6QBLDP1qPiREfoj3z+hw=
Date: Tue, 17 Feb 2009 09:52:00 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Karl Hiramoto <karl@hiramoto.org>, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: problem with IPoA (CLIP),  NAT, and VLANS
Message-ID: <20090217095200.GA5538@ff.dom.local>
References: <20090216232016.GA4803@ami.dom.local> <499A7D7D.1090607@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499A7D7D.1090607@trash.net>
X-Mutt-References: <499A7D7D.1090607@trash.net>
X-Mutt-Fcc: =outbox
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:03:57AM +0100, Patrick McHardy wrote:
...
> The first patch looks fine. As for the second one, I would like
> to understand why we're seing these packets. The VLAN driver uses
> the original headroom plus the space it needs itself, which suggests
> that the underlying driver specifies an incorrect headroom.
> The driver doesn't appear to be part of the mainline kernel though.

On the other hand, if Karl added his patch it seems this change of
NET_SKB_PAD isn't enough, and if omitting skb_cow_head() works, then
the headroom isn't the main problem?

Jarek P.
