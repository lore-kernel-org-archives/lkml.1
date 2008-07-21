Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYGUBYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYGUBYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYGUBYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:24:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:16331 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbYGUBYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HFWOBzVtqo41eHMjtl2Wyk7KG8TIHqSEGC/ex0ghPYN+0yGizaI08iJ6vFpNzMH3EQ
         nF5hJFs5v8f3P+Rzj396JH76MRdd18dcMnzlxNXb7ps7sSFS56ZTjBJM65tH0+PBnR3U
         W67TLodW7yPCcOCobRCd9NGviJCB7nRAIVaC8=
Date: Mon, 21 Jul 2008 05:22:26 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20080721012225.GA4808@martell.zuzino.mipt.ru>
References: <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org> <20080720.180304.51601407.davem@davemloft.net> <20080721010952.GA4822@martell.zuzino.mipt.ru> <20080720.181440.122144107.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720.181440.122144107.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 06:14:40PM -0700, David Miller wrote:
> > And finally, boot process hangs after TCP cubic is initialized.
> 
> That very much should not happen.  Can you turn on initcall
> tracing so we can see where that is happening exactly?

Before that BUG_ON in __netif_schedule() happens (and quickly scrolls
off). But after netconsole ups device (which is ATL1 if it matters).

