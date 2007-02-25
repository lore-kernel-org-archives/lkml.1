Return-Path: <linux-kernel-owner+w=401wt.eu-S964788AbXBYLSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788AbXBYLSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 06:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964800AbXBYLSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 06:18:31 -0500
Received: from [212.12.190.241] ([212.12.190.241]:32830 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S964788AbXBYLSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 06:18:31 -0500
From: Al Boldi <a1426z@gawab.com>
To: netdev@vger.kernel.org
Subject: Re: ipv4 and ipv6 stacks for new link layers?
Date: Sun, 25 Feb 2007 14:21:16 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702251421.16863.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Markku Savela <msa@moth.iki.fi>
> > I think that is worse than allow a new driver to provide a simple
> > service function which maps IPv4/6 multicast address into link layer
> > address, when asked.
>
> The problem is that this mapping isn't so simple for several
> link layer types.

But this mapping seems to be just a simple de-coupling tool, and any 
de-coupling by definition does/should not change the underlying 
implementation in any way, while allowing for a dynamic rather than a 
fixed/hardcoded relation between the layers.

So, can you give an example of a link-layer that does not easily de-couple 
from the transport?


Thanks!

--
Al

