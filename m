Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYGWKJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYGWKJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 06:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYGWKIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 06:08:50 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:48552 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbYGWKIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 06:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Czcla9Z26537Yq/+dBkFzHVMLz1HwJVakzLWxFBqRY1U76lKIpkh4pHkNWXhB2G+iK
         y0iVOaBDO/cKlkonuvoh4qA5iGDGDXdzrW1KnPBRCuD5KQTlHhQKQSlHYRHZdyvYZQgP
         VWDkEXwK+A5CLFj/XlVIPrKw8l4O7SeUfUa5M=
Date: Wed, 23 Jul 2008 10:13:52 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, Larry.Finger@lwfinger.net,
       kaber@trash.net, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723101352.GD4561@ff.dom.local>
References: <20080722.160409.216536011.davem@davemloft.net> <20080723062036.GA4561@ff.dom.local> <20080723.005921.113868915.davem@davemloft.net> <20080723085452.GB4561@ff.dom.local> <1216803786.7257.146.camel@twins> <20080723093459.GC4561@ff.dom.local> <1216806614.7257.152.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216806614.7257.152.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 11:50:14AM +0200, Peter Zijlstra wrote:
...
> definite NAK on using raw spinlock ops...
> 
> I'll go look at this multiqueue stuff to see if there is anything to be
> done.. David, what would be a good commit to start reading?

...In the case David ever sleeps: I think, the current Linus' git is
good enough (the problem is with netdevice.h: netif_tx_lock()).

Jarek P.
