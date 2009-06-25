Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZFYEc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZFYEc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 00:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZFYEcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 00:32:20 -0400
Received: from mail.lang.hm ([64.81.33.126]:39673 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbZFYEcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 00:32:19 -0400
Date: Wed, 24 Jun 2009 21:32:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: alex@digriz.org.uk, linux-kernel@vger.kernel.org
Subject: Re: When does Linux drop UDP packets?
In-Reply-To: <20090624074737.GA19794@gondor.apana.org.au>
Message-ID: <alpine.DEB.1.10.0906242129320.28437@asgard.lang.hm>
References: <20090624074737.GA19794@gondor.apana.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Herbert Xu wrote:

> david@lang.hm wrote:
>>
>> there is only a difference between multicast and broadcast traffic if you
>> are spanning subnets.
>
> Which is always the case if you invest in some intelligent switches.

given that each subnet will be a minimum of 4 IP addresses (the network 
address, two useable, and thr broadcast address), putting each machine on 
it's own subnet and routing between them on the switch would be very 
wasteful of addresses.

if you use larger subnets, your switch still has the ability to filter 
things out when they move from port to port, but broadcasts (unless you 
filter them) still cover the entire subnet.

so No, buying intelligent switches doesn't mean that you are always 
spanning subnets.

David Lang
