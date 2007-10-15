Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbXJOIiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbXJOIiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbXJOIiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:38:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47031
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbXJOIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:38:06 -0400
Date: Mon, 15 Oct 2007 01:38:10 -0700 (PDT)
Message-Id: <20071015.013810.59671955.davem@davemloft.net>
To: takamiya@po.ntts.co.jp
Cc: nakam@linux-ipv6.org, bunk@kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] __inet6_csk_dst_store(): fix check-after-use
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071015.123749.497715418.takamiya@po.ntts.co.jp>
References: <20071014175212.GP4211@stusta.de>
	<20071015113723.00F7.NAKAM@linux-ipv6.org>
	<20071015.123749.497715418.takamiya@po.ntts.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Date: Mon, 15 Oct 2007 12:37:49 +0900 (JST)

> > 
> > On Sun, 14 Oct 2007 19:52:12 +0200
> > Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > The Coverity checker spotted that we have already oops'ed if "dst"
> > > was NULL.
> > > 
> > > Since "dst" being NULL doesn't seem to be possible at this point this 
> > > patch removes the NULL check.
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> > Agreed.
> > 
> > Acked-by: Masahide NAKAMURA <nakam@linux-ipv6.org>
> 
>   I also agreed.
>   
> Acked-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

Patch applied, thanks everyone!
