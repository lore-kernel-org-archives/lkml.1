Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZDBGrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZDBGrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZDBGrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:47:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53305 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZDBGrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:47:07 -0400
Message-ID: <49D45F59.9030100@redhat.com>
Date: Thu, 02 Apr 2009 09:46:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Anthony Liguori <anthony@codemonkey.ws>, andi@firstfloor.org,
       ghaskins@novell.com, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402030935.GA27836@gondor.apana.org.au>
In-Reply-To: <20090402030935.GA27836@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Anthony Liguori <anthony@codemonkey.ws> wrote:
>   
>> That said, I don't think we're bound today by the fact that we're in 
>> userspace.  Rather we're bound by the interfaces we have between the 
>> host kernel and userspace to generate IO.  I'd rather fix those 
>> interfaces than put more stuff in the kernel.
>>     
>
> I'm sorry but I totally disagree with that.  By having our IO
> infrastructure in user-space we've basically given up the main
> advantage of kvm, which is that the physical drivers operate in
> the same environment as the hypervisor.
>   

I don't understand this.  If we had good interfaces, all that userspace 
would do is translate guest physical addresses to host physical 
addresses, and translate the guest->host protocol to host API calls.  I 
don't see anything there that benefits from being in the kernel.

Can you elaborate?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

