Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbYBST0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbYBST0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYBST0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:26:08 -0500
Received: from host64.cybernetics.com ([70.169.137.4]:3056 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbYBST0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:26:07 -0500
Message-ID: <47BB2D50.2060805@cybernetics.com>
Date: Tue, 19 Feb 2008 14:26:08 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Michael Chan <mchan@broadcom.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       netdev <netdev@vger.kernel.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
References: <47BA0984.2070306@cybernetics.com> <1203381120.13495.78.camel@dell> <20080218.163554.74130592.davem@davemloft.net> <1203383046.13495.87.camel@dell> <47BB00EC.3010607@cybernetics.com> <1203448265.13495.95.camel@dell>
In-Reply-To: <1203448265.13495.95.camel@dell>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Chan wrote:
>> The SysKonnect NIC that does not exhibit this problem has a chip that
>> says "BCM5411KQM" "TT0128 P2Q" and "56975E".
> I think this is the 5700, but please send me the tg3 output that
> identifies the chip and the revision.  Something like this:
>
> eth2: Tigon3 [partno(BCM95705) rev 3003 PHY(5705)] (PCI:66MHz:32-bit) 10/100/1000Base-T Ethernet 00:10:18:04:57:0d
> eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
>   
Here is the dmesg output for the SysKonnect NIC:

eth0: Tigon3 [partno(SK-9D21) rev 7104 PHY(5411)] (PCI:66MHz:64-bit)
10/100/1000Base-T Ethernet 00:00:5a:9d:0c:4a
eth0: RXcsums[1] LinkChgREG[1] MIirq[1] ASF[0] WireSpeed[0] TSOcap[0]
eth0: dma_rwctrl[76ff000f] dma_mask[64-bit]

Tony

