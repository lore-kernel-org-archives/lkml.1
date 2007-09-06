Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbXIFK13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbXIFK13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXIFK1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:27:19 -0400
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:39640 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXIFK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:27:18 -0400
X-Greylist: delayed 1463 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 06:27:17 EDT
Date: Thu, 06 Sep 2007 19:01:20 +0900 (JST)
Message-Id: <20070906.190120.432840050.takamiya@po.ntts.co.jp>
To: dada1@cosmosbay.com
Cc: divy@chelsio.com, davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, usagi-core@linux-ipv6.org
Subject: Re: net-26.24 broken with XFRM off
From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
In-Reply-To: <20070906101326.34a81abb.dada1@cosmosbay.com>
	<20070903193711.6A1D.NAKAM@linux-ipv6.org>
References: <46DFAB7F.7060406@chelsio.com>
	<20070906101326.34a81abb.dada1@cosmosbay.com>
X-Face: +<)&j!Ce24nM@a.\f6TA,]^9Q76[_QN_[QR-(bT&>b40Oo[:`R(>b7!b-|q5k&.8CO[_Oh_
 !9Nk0rikK70~?|08EFH|:]iF6pwPlnfEn-wo-voY:rP?%7p%cxjnbf'hglO'se&QwZN7/RVX!U7*P%
 cTV('HfHp+?g1+hx7\+J.W]<O~hbwx[4hPPO=T<7aV2^7["&p^h4:YbY6,bS,ecZ7S5<pIUTnT''}k
 ={TEs)bN%-8Jdo~.Q_lpa-fN^.Fo9dFB*}\@=PK@0pmvZ3k0p-5hMQ<bjyK{enk/sOQ[<(k]}Q\p>G
 zYWv%LsDc
X-Mailer: Mew version 5.2 on XEmacs 21.4.19 (Constant Variable)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> Thu, 6 Sep 2007 10:13:26 +0200
>> [Subject: Re: net-26.24 broken with XFRM off]
>> Eric Dumazet <dada1@cosmosbay.com> wrote...

> Hi Divy
> 
> I believe this problem is known.
> 
> Please check http://marc.info/?l=linux-netdev&m=118881627028135&w=2 

  I'm sorry not to check more precisely.

  As Eric said, this issue should be fixed by the patch attached in
  the following mail.

  Regards,

>> Mon, 03 Sep 2007 19:43:51 +0900
>> [Subject: Re: [-mm patch] IPV6 must select XFRM]
>> Masahide NAKAMURA <nakam@linux-ipv6.org> wrote...

> Thank you for catching this. the issue is caused with patch
> "[IPV6] XFRM: Fix connected socket to use transformation."
> which I sent to netdev.
> (a85d5450ddeb959bdf9e4603f9c06e9d79217cfa on net-2.6.24).
> 
> I'd prefer to modify the original patch to use "ifdef CONFIG_XFRM"
> than changing kernel config depends. Does it make sense?
> 
> Please review the attached patch.
> 
> -- 
> Masahide NAKAMURA
--
Noriaki TAKAMIYA
