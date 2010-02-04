Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab0BDMu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 07:50:58 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:50797 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756508Ab0BDMu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 07:50:56 -0500
Message-ID: <4B6AC28D.6090204@st.com>
Date: Thu, 04 Feb 2010 13:50:21 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       lsorense@csclub.uwaterloo.ca, netdev@vger.kernel.org, daniel@caiaq.de
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
References: <20100203133011.75aef1d3.sfr@canb.auug.org.au> <alpine.LNX.2.00.1002031136560.15395@pobox.suse.cz> <20100203.200402.17600564.davem@davemloft.net> <alpine.LNX.2.00.1002041052020.15395@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1002041052020.15395@pobox.suse.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Jiri,

Jiri Kosina wrote:
> On Wed, 3 Feb 2010, David Miller wrote:
> 
>>> I think the best thing is me dropping the net/ and drivers/net hunks of 
>>> this patch and taking it through Davem's tree ... I have already dropped 
>>> those hunks from my tree. Dave, the patch is below, please consider 
>>> applying.
>>  ...
>>> From: Daniel Mack <daniel@caiaq.de>
>>> Subject: [PATCH] net: fix 'lenght' typo in comments and code
>>>
>>> Some misspelled occurences of 'octet' and some comments were also fixed
>>> as I was on it.
>>>
>>> Signed-off-by: Daniel Mack <daniel@caiaq.de>
>>> Cc: Jiri Kosina <trivial@kernel.org>
>>> Cc: Joe Perches <joe@perches.com>
>>> Cc: Junio C Hamano <gitster@pobox.com>
>>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> This doesn't apply to net-next-2.6 at all:
>>
>> error: patch failed: drivers/net/ppp_generic.c:1436
>> error: drivers/net/ppp_generic.c: patch does not apply
>> error: drivers/net/stmmac/gmac.c: does not exist in index
>> error: drivers/net/stmmac/mac100.c: does not exist in index

The stmmac driver included in net-next has been restructured: for this
reason both gmac.c and mac100.c files do not exist any more.

Let me know if I can help on this; I mean I'm happy to apply this latest
changes to the stmmac in net-next and send a new patch.

Peppe

> Daniel, could you please refresh the drivers/net/ and net/ bits of your 
> patch and resent it to netdev/Dave?
> 
> I have already dropped it from my queue.
> 
> Thanks,
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAktqwo0ACgkQ2Xo3j31MSSLr+QCeM4cA87vv6uQoY1rHf4Wl7Ye8
v1wAnAtI6RWt5wNUFJZRTQ2mEOP4EuE9
=G2hJ
-----END PGP SIGNATURE-----
