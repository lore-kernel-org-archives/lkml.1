Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYCHEsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYCHEsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 23:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYCHEsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 23:48:15 -0500
Received: from userg500.nifty.com ([202.248.238.80]:36310 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYCHEsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 23:48:15 -0500
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=JwzeAHCyuU0rhb68TOeuJJ02rzGVy+4puQh6NhQm8fRNauEuc3p5vwAgS3WUv8RJQ
	ydiJ+ZmYR/tM/hn4hAtaA==
X-Nifty-SrcIP: [219.116.17.165]
Date: Sat, 8 Mar 2008 13:44:10 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [BUG  kernel 2.6.25-rc3  IPV6]  ping6 -I eth0 ff02::1 causes
 system hang.
Message-Id: <20080308134410.69d07a2d.komurojun-mbn@nifty.com>
In-Reply-To: <20080302210716.69727582.komurojun-mbn@nifty.com>
References: <20071006132601.f944f461.komurojun@nifty.com>
	<20071014073658.d4352b8c.komurojun@nifty.com>
	<20080302210716.69727582.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>Hmm, I've never seen this on our testlab.  Anyone else?

Could you send 20(twenty) or more ping packets?


>It would be great if you have chance to bisect it...On Sun, 2 Mar 2008 21:07:16 +0900

The bad commit is below.

69cc64d8d92bf852f933e90c888dfff083bd4fc9 is first bad commit
commit 69cc64d8d92bf852f933e90c888dfff083bd4fc9
Author: David S. Miller <davem@davemloft.net>
Date:   Mon Feb 11 21:45:44 2008 -0800

    [NDISC]: Fix race in generic address resolution

    Frank Blaschka provided the bug report and the initial suggested fix
    for this bug.  He also validated this version of this fix.




> Hi,
> 
> On kernel 2.6.25-rc3, IPV6 multicast ping causes system hang
> after sending several multicast ping packet.
> 
> >ping6 -I eth0 ff02::1 
> 
> This problem does not happen on kernel 2.6.24.
> (does not depend on NIC)

 
Best Regards
Komuro
 
 

