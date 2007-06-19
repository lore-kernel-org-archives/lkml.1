Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbXFSOky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbXFSOky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXFSOkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:40:32 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:58092 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbXFSOka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:40:30 -0400
Message-ID: <4677EACF.2000202@free.fr>
Date: Tue, 19 Jun 2007 16:40:15 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Dumping the checksums in a module
References: <4677C539.7020203@free.fr> <1182259085.3014.5.camel@laptopd505.fenrus.org>
In-Reply-To: <1182259085.3014.5.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> On Tue, 2007-06-19 at 13:59 +0200, John Sigler wrote:
>
>> As far as I understand (which is not very far), if I define
>> CONFIG_MODVERSIONS,
> 
> just don't enable modversions.. it doesn't provide you any real safety
> at all..... and it makes your build a LOT slower.

I'm confused. What is the consensus on MODVERSIONS around here?
How many people share your views?

I was under the impression MODVERSIONS was a good thing(TM).

If I don't enable CONFIG_MODVERSIONS, then I'll have to recompile my 
out-of-tree modules every time I upgrade the kernel, even if I'm just 
upgrading from 2.6.20.7 to 2.6.20.8, unless I force the insertion.

I also have a few binary modules. If I force the insertion, I won't know 
they have become binary incompatible until they blow up later, or, 
worse, lead to silent corruption.

Please correct any and all misconceptions.

Regards.
