Return-Path: <linux-kernel-owner+w=401wt.eu-S1764890AbXEVJnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764890AbXEVJnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbXEVJnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:43:39 -0400
Received: from tang.lemonia.org ([88.208.192.38]:50876 "EHLO tang.lemonia.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbXEVJni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:43:38 -0400
X-Greylist: delayed 2326 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 05:43:38 EDT
Message-ID: <4652B227.60404@lemonia.org>
Date: Tue, 22 May 2007 10:04:39 +0100
From: Dunc <dunc@lemonia.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Marc Donner <webmaster@poweraudio.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <C2786969.24B46%webmaster@poweraudio.de> <20070522105738.f03cb83b.dada1@cosmosbay.com>
In-Reply-To: <20070522105738.f03cb83b.dada1@cosmosbay.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 213.129.64.4
Subject: Re: TCP_MD5 and Intel e1000
X-SA-Exim-Version: 4.2
X-SA-Exim-Scanned: Yes (on tang.lemonia.org)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> On Tue, 22 May 2007 09:33:29 +0200
> Marc Donner <webmaster@poweraudio.de> wrote:
> 
>> Hi,
>>
>> I have tried to set up quagga with tcp-md5 support from kernel. All seems ok
>> with a intel e100 NIC, but as i testetd with a intel e1000 NIC the tcp
>> packets have an invalid md5 digest.
>> If i run tcpdump on the mashine the packets are generated, it shows on the
>> outgoing interface invalid md5 digests.
>> Are there known issues about tcp-md5 and e1000 NICs?
>>
> 
> Hi Marc
> 
> CCed netdev as more appropriate to discuss about network stuff.
> 
> Would be nice if you sent some tcpdump samples to share with us, and tell us
> which exact linux version you tried.
> 
> You could try "ethtool -K tx off", and/or other ethtool -K settings
> 
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I had this with e1000 NICs and it was just because I had TSO on.

It is disabled with ethtool as Eric suggests

Cheers,

Dunc
