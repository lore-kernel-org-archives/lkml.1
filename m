Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab0BPTMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 14:12:18 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:65137 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091Ab0BPTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 14:12:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AT3CEH9WrGRNEtLTiHnMKq2T+ZnS4jpybymBFK46cmb9hyvUuAtodol25HsRX64nRp
         ekP5HkwHx8QOf6fQ0FLCbWiJZsWEAtaMRaVPBLOS71E+uSW5Yd94UqkYY0hp11IVQ2Ki
         p5rMFQT0Z+Kc1BQBrK9x5Gk9+yLs/ZWN1wknI=
Message-ID: <4B7AEE0B.4050607@lwfinger.net>
Date: Tue, 16 Feb 2010 13:12:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mb@bu3sch.de,
       davem@davemloft.net, stefano.brivio@polimi.it,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] ssb: open-code dma_alloc_coherent
References: <4B78EE6A.3010207@lwfinger.net>	<20100215162426V.fujita.tomonori@lab.ntt.co.jp>	<4B79E251.3020005@lwfinger.net> <20100216110422O.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100216110422O.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 08:05 PM, FUJITA Tomonori wrote:
> On Mon, 15 Feb 2010 18:09:53 -0600
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> On 02/15/2010 01:25 AM, FUJITA Tomonori wrote:
>>> 2.6.33-rc8:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git pending
>>>
>>> The ssb patch depends on the latest eight patches in the tree:
>>>
>>> http://marc.info/?l=linux-kernel&m=126596737604808&w=2
>>
>> The DMA changes work on i386 architecture with wireless devices in Cardbus (PCI)
>> format. Both b43legacy and b43 were tested.
> 
> Great, thanks a lot!
> 
> I've posted the second version:
> 
> http://marc.info/?l=linux-kernel&m=126624677226865&w=2
> 
> It's also available via the git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git pending
> 
> Can I get your ack on b43 stuff?
> 

Both b43 and b43legacy changes are

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

