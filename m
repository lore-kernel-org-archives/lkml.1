Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbXK0FdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbXK0FdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXK0Fcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:32:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:1675 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbXK0Fcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YGFWve1QylrYdTj1tpx6D/5xF7nC8Yr+8H0WEMhUc2JVrMICcCtLJ/FcXzEEwPHD2nm/1roj8j3tD+BjlFKFT/hRGoPfu8FQQcu4wB/tsImxFm710+uxI53mPIf/L0rjEP2cSWalKoi0f9ZKm9jhEds6Ar9bQ6KqNcT5NqGdtaA=
Message-ID: <b25c3fa70711262132r3f88db02mcede6d14b82d5fc0@mail.gmail.com>
Date: Tue, 27 Nov 2007 14:32:49 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [NET]: Fix TX bug VLAN in VLAN
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
       tristan_schmelcher@alumni.uwaterloo.ca, acme@ghostprotocols.net
In-Reply-To: <20071126112631.GA26599@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <003f01c82dca$305acd40$9c94fea9@jason>
	 <20071126112631.GA26599@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/26, Herbert Xu <herbert@gondor.apana.org.au>:
> On Fri, Nov 23, 2007 at 12:12:52PM +0000, Joonwoo Park wrote:
> > This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=8766
> >
> > Is it possible?
> > BUG((veth->h_vlan_proto != htons(ETH_P_8021Q)) && !(VLAN_DEV_INFO(dev)->flags & VLAN_FLAG_REORDER_HDR))
> > I'm afraid, queued packet before vconfig set_flag would do that.
>
> Yes, AF_PACKET would do that.  So you should check both.
>

Thanks Herbert.
Well.. I think patch would work propely for AF_PACKET also.
(I did not insert BUG() macro in my patch)
How do you think?

Thanks
Joonwoo
