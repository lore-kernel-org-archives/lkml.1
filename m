Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbXJOD5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbXJOD5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 23:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbXJOD46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 23:56:58 -0400
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:62087 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbXJOD44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 23:56:56 -0400
X-Greylist: delayed 1088 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 23:56:56 EDT
Date: Mon, 15 Oct 2007 12:37:49 +0900 (JST)
Message-Id: <20071015.123749.497715418.takamiya@po.ntts.co.jp>
To: nakam@linux-ipv6.org
Cc: bunk@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] __inet6_csk_dst_store(): fix check-after-use
From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
In-Reply-To: <20071015113723.00F7.NAKAM@linux-ipv6.org>
References: <20071014175212.GP4211@stusta.de>
	<20071015113723.00F7.NAKAM@linux-ipv6.org>
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

>> Mon, 15 Oct 2007 11:45:10 +0900
>> [Subject: Re: [2.6 patch] __inet6_csk_dst_store(): fix check-after-use]
>> Masahide NAKAMURA <nakam@linux-ipv6.org> wrote...

> 
> On Sun, 14 Oct 2007 19:52:12 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > The Coverity checker spotted that we have already oops'ed if "dst"
> > was NULL.
> > 
> > Since "dst" being NULL doesn't seem to be possible at this point this 
> > patch removes the NULL check.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Agreed.
> 
> Acked-by: Masahide NAKAMURA <nakam@linux-ipv6.org>

  I also agreed.
  
Acked-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

--
Noriaki TAKAMIYA
