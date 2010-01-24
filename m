Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750Ab0AXHRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0AXHRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 02:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360Ab0AXHR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 02:17:29 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:36079 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0AXHR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 02:17:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=q9ERQwEsmBvVWnOYgcbuj9AQCzLZIEkz4gVQkJ9Jd+lWQogWPz8HMl2HVRW3eTc4Cw
         89a6561YCEMB0UNl2AWbNdEhsL5tWweumzjVMtqH5yEtXRVIuDvyCkIbQBfOaMUXdfS1
         mAk8SVE9MfhA/n40G3sWgnGTIozk03csNE0pA=
Date: Sun, 24 Jan 2010 09:17:28 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in
 vlan_skb_recv - probably introduced by commit
 9793241fe92f7d9303fb221e43fc598eb065f267
Message-ID: <20100124071728.GA3993@x200>
References: <20100123165657.187c11e4@neptune.home>
 <20100124071252.GA11037@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100124071252.GA11037@hack>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 03:12:52PM +0800, Américo Wang wrote:
> On Sat, Jan 23, 2010 at 04:56:57PM +0100, Bruno Prémont wrote:
> >Today I tried out 2.6.33-rc5 but always got crashing system:
> >
> >[   26.390576] BUG: unable to handle kernel NULL pointer dereference at (null)
> >[   26.396369] IP: [<df856b89>] vlan_skb_recv+0x89/0x280 [8021q]
> 
> 
> What does 'addr2line -e vmlinux 0xdf856b89' say?

EIP is in module, so it will say nothing.
