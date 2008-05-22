Return-Path: <linux-kernel-owner+w=401wt.eu-S937839AbYEVAh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937839AbYEVAh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765081AbYEVAhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:37:48 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:52369 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764041AbYEVAhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bDymn+n2S17mgZyHEj/tbKrfO6v0Npiq6qIK5+BK4iuTNu+7VQXue/KYsC2g1uvLvtxofaKneI/sYhXzYb+fSxiMsTYzmhLkqL+OxL49xsQdAq1WZjvEWUrR9celq/bvZQrBwNICEJMzYh193wC/QGhpqOePL0KVzH1biWfgOJg=
Subject: Re: [PATCH] net/ipv4/arp.c: Use the exported hex_asc from
	lib/hexdump.c instead
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: crquan@gmail.com, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080521.173521.265981118.davem@davemloft.net>
References: <1211323212.5915.220.camel@brick>
	 <20080520.154551.54365414.davem@davemloft.net>
	 <91b13c310805201927k4fccf8dcwa3fabe61777b2eda@mail.gmail.com>
	 <20080521.173521.265981118.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 21 May 2008 17:37:44 -0700
Message-Id: <1211416664.6908.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 17:35 -0700, David Miller wrote:
> From: "rae l" <crquan@gmail.com>
> Date: Wed, 21 May 2008 10:27:41 +0800
> 
> > net/ipv4/arp.c: Use common hex_asc helpers
> > 
> > Here the local hexbuf is a duplicate of global const char hex_asc from
> > lib/hexdump.c, except the hex letters' cases:
> > 
> > 	const char hexbuf[] = "0123456789ABCDEF";
> > 
> > 	const char hex_asc[] = "0123456789abcdef";
> > 
> > and here to print HW addresses, the hex cases are not significant.
> > 
> > Thanks to Harvey Harrison to introduce the hex_asc_hi/hex_asc_lo helpers.
> > 
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Applied, thanks.
> 
> Harvey I know you posted a nearly identical patch, I had
> to choose one and he did credit you with the idea for the
> updated patch, so I hope this is OK.

His had the better changelog, I just sent mine to make my point clear
what the patch could look like.

No problems here.

Harvey

