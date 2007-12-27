Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbXL0EBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbXL0EBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 23:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbXL0EBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 23:01:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:50947 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbXL0EBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 23:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MB0zL5hBhKXvZhjOWlDoL7ZgHM8uFTF/mDqiqdvA9HgFWJxUpB852ajxCta/+KFqnMI86unrV9E/JvxeahFKw7pLiTpegEYcOObNmPNrYXscE6PjFTRRor8RItPp8Y3kdjkAGLfzu+OpWYmVSyKP95EY45BpHOqTH2PsvGO5Zf0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net/ipv4/netfilter/ip_tables.c: remove some inlines
Date: Thu, 27 Dec 2007 04:01:35 +0000
User-Agent: KMail/1.9.1
Cc: Harald Welte <laforge@gnumonks.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
References: <200712161247.53986.vda.linux@googlemail.com> <47668BE9.8010504@trash.net>
In-Reply-To: <47668BE9.8010504@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712270401.35983.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 December 2007 14:47, Patrick McHardy wrote:
> Please CC netfilter-devel on netfilter patches.
>
> Denys Vlasenko wrote:
> > Hi Patrick, Harald,
> >
> > I was working on unrelated problem and noticed that ip_tables.c
> > seem to abuse inline. I prepared a patch which removes inlines
> > except those which are used by packet matching code
> > (and thus are really performance-critical).
> > I added comments explaining that remaining inlines are
> > performance critical.
> >
> > Result as reported by size:
> >
> >    text    data     bss     dec     hex filename
> > -  6451     380      88    6919    1b07 ip_tables.o
> > +  6339     348      72    6759    1a67 ip_tables.o
> >
> > Please take this patch into netfilter queue.
>
> This clashes with my pending patches, which I'll push upstream
> today. I also spent some time resyncing ip_tables and ip6_tables
> so a diff of both (with some sed'ing) shows only the actual
> differences, so please update ip6_tables as well.

I would be happy to rediff the patch.

Which tree should I sync against in order to not collide
with your changes?
--
vda
