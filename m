Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbZDCMCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbZDCMCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760657AbZDCMCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:02:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228AbZDCMCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:02:04 -0400
Message-ID: <49D5FACE.3010302@redhat.com>
Date: Fri, 03 Apr 2009 15:02:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Gerd Hoffmann <kraxel@redhat.com>, ghaskins@novell.com,
       anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D5EBE1.8030200@redhat.com> <49D5ED11.2000800@redhat.com> <20090403111242.GA10200@gondor.apana.org.au> <49D5F6FC.5090401@redhat.com> <20090403114828.GA10465@gondor.apana.org.au> <49D5F8DA.20400@redhat.com> <20090403115546.GA10575@gondor.apana.org.au>
In-Reply-To: <20090403115546.GA10575@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Fri, Apr 03, 2009 at 02:54:02PM +0300, Avi Kivity wrote:
>   
>> It doesn't copy and queue the packet?  We use O_NONBLOCK and poll() so  
>> we can tell when we can queue without blocking.
>>     
>
> Well netif_rx queues the packet, but netif_rx_ni is netif_rx plus
> an immediate flush.
>   

But it flushes the tap device, the packet still has to go through the 
bridge + real interface?

Even if it's queued there, I want to know when the packet is on the 
wire, not on some random software or hardware queue in the middle.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

