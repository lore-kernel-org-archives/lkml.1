Return-Path: <linux-kernel-owner+w=401wt.eu-S1032108AbXEHVF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032108AbXEHVF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967801AbXEHVFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:05:53 -0400
Received: from gw.goop.org ([64.81.55.164]:60336 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967789AbXEHVFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:05:52 -0400
Message-ID: <4640E62D.8060704@goop.org>
Date: Tue, 08 May 2007 14:05:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: David Rientjes <rientjes@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com>	<20070430235642.e576e917.akpm@linux-foundation.org>	<20070508121404.17bd97a6.randy.dunlap@oracle.com>	<alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> <m3k5vj2iha.fsf@maximus.localdomain>
In-Reply-To: <m3k5vj2iha.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> David Rientjes <rientjes@google.com> writes:
>
>   
>> Since 'volatile' has two different semantics depending on the context in 
>> which it is used, this warning should be appended to include the fact that 
>> it is legitimate to use for inline assembly.
>>     
>
> I think it hasn't two semantics, it's like arguing that char has two
> semantics.
>   

No, David means that "asm volatile (...)" is meaningful and OK to use.

    J
