Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYILDFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYILDFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 23:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbYILDEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 23:04:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50969
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755892AbYILDEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 23:04:44 -0400
Date: Thu, 11 Sep 2008 20:04:38 -0700 (PDT)
Message-Id: <20080911.200438.01253897.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: gcoady.lk@gmail.com, grant_lkml@dodo.com.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [stable] regression in iptables: recent filter
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080911200133.48be32fa.akpm@linux-foundation.org>
References: <ejijc4dc92n75s2el334e7dgdanngs7qv3@4ax.com>
	<20080911200133.48be32fa.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 11 Sep 2008 20:01:33 -0700

> On Fri, 12 Sep 2008 11:53:35 +1000 Grant Coady <grant_lkml@dodo.com.au> wrote:
> 
> > Hi there,
> > 
> > Last known good kernel: 2.6.24.7
> > 
> > # iptables -N calmrate
> > # iptables -A calmrate -p tcp -m state --state NEW \
> > 	-m recent --name listrate --update --rttl \
> > 	--seconds 60 --hitcount 60 -j DROP
> > iptables: Unknown error 4294967295
> > 
> > Fails for 2.6.25.17 and 2.6.26.5
> > 
> > dmesg + config: http://bugsplatter.id.au/kernel/boxen/deltree/
> > 
> 
> (cc netdev)

(cc netfilter-devel)

For those playing at home, 4294967295 is 32-bit -1.
