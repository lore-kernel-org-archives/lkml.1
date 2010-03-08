Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0CHN7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:59:20 -0500
Received: from mx2.netapp.com ([216.240.18.37]:24862 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0CHN7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:59:17 -0500
X-IronPort-AV: E=Sophos;i="4.49,602,1262592000"; 
   d="scan'208";a="327861965"
Subject: Re: [PATCH resend] net/sunrpc: Remove uses of NIPQUAD, use %pI4
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100307.152830.191688665.davem@davemloft.net>
References: <1267857980.849.22.camel@Joe-Laptop.home>
	 <20100307.152830.191688665.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Mon, 08 Mar 2010 08:58:27 -0500
Message-ID: <1268056707.3097.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 08 Mar 2010 13:59:01.0348 (UTC) FILETIME=[81799A40:01CABEC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-07 at 15:28 -0800, David Miller wrote: 
> From: Joe Perches <joe@perches.com>
> Date: Fri, 05 Mar 2010 22:46:20 -0800
> 
> > Originally submitted Jan 1, 2010
> > http://patchwork.kernel.org/patch/71221/
> > 
> > Convert NIPQUAD to the %pI4 format extension where possible
> > Convert %02x%02x%02x%02x/NIPQUAD to %08x/ntohl
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Trond, are you going to integrate this?
> 
> Otherwise I'm going to.

If you're planning another push to Linus then feel free to push this
too.

If not, then I do have a couple of small cleanups and fixes that I want
to push before the merge window closes, so I could send Joe's patch
together with those...

Cheers
  Trond
