Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0BAUlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:41:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:49490 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0BAUl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hAj6McYEHVOcQxoinjHhvx2lp2XWSwCBhjEn94n7CdxyK8gPjC4ZG01MyuHhrkKK5b
         KfD7PC+Xi27tggb8pyUDdunOPM5zltvEdmCcTKEW60Uu6MNiVlHqgQBs2CR5JL6W/bWM
         DwAH2L4wNm5lOUOQKstER7akgBLfdIyX6JJUk=
Date: Mon, 1 Feb 2010 21:41:22 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Michael Breuer <mbreuer@majjas.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH] sky2:  receive dma mapping error handling
Message-ID: <20100201204122.GB3096@del.dom.local>
References: <4B6216B9.1010802@majjas.com>
 <20100128153643.0fca3c51@nehalam>
 <4B645EF4.4050701@majjas.com>
 <20100131003449.GA11935@del.dom.local>
 <4B650D53.2010607@majjas.com>
 <4B65D0F9.2020602@majjas.com>
 <4B65FD12.7090101@majjas.com>
 <20100131221835.GA3317@del.dom.local>
 <20100201102018.7b597992@nehalam>
 <20100201201323.GA3096@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201201323.GA3096@del.dom.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 09:13:23PM +0100, Jarek Poplawski wrote:
> On Mon, Feb 01, 2010 at 10:20:18AM -0800, Stephen Hemminger wrote:
> > This fixes the fact that re->flags is always zero without causing
> > other confusion.
> 
> Actually, there is a slight confusion: after tx_init() slots #0 are
> skipped and waiting for tx_complete. Of course, no big deal, but no
> problem with fixing it too, so there is the main difference between

Hmm... On the other hand it could be fixed simpler by moving
sky2->tx_cons. I'll send v3.

Thanks,
Jarek P.
