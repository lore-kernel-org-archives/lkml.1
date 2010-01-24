Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908Ab0AXH2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0AXH2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 02:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790Ab0AXH2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 02:28:19 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38395 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0AXH2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 02:28:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=A/ZN965SuPoA3DziE7oUw2qivU/RVitgIi+foiYAynW54iN3lPrLQF1DzzWRAtyH8O
         QBYOgiIRNhO3KOiHUQe8bQwBlCCyK0utApdOs+NT+vfITLHXUVd310cEvPqYDHF7uQBu
         q/AMMzoF5zRFxQCPGZOAxOqjISqLcuWibJBAA=
Date: Sun, 24 Jan 2010 15:30:22 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc5 regression] NULL pointer dereference in
	vlan_skb_recv - probably introduced by commit
	9793241fe92f7d9303fb221e43fc598eb065f267
Message-ID: <20100124073022.GB11037@hack>
References: <20100123165657.187c11e4@neptune.home> <20100124071252.GA11037@hack> <20100124071728.GA3993@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100124071728.GA3993@x200>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 09:17:28AM +0200, Alexey Dobriyan wrote:
>On Sun, Jan 24, 2010 at 03:12:52PM +0800, Américo Wang wrote:
>> On Sat, Jan 23, 2010 at 04:56:57PM +0100, Bruno Prémont wrote:
>> >Today I tried out 2.6.33-rc5 but always got crashing system:
>> >
>> >[   26.390576] BUG: unable to handle kernel NULL pointer dereference at (null)
>> >[   26.396369] IP: [<df856b89>] vlan_skb_recv+0x89/0x280 [8021q]
>> 
>> 
>> What does 'addr2line -e vmlinux 0xdf856b89' say?
>
>EIP is in module, so it will say nothing.

Oh, ok, then '-e net/8021q/vlan_dev.o'.

-- 
Live like a child, think like the god.
 
