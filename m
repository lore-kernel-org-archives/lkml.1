Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXFYCSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXFYCSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 22:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXFYCSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 22:18:47 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:54732
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXFYCSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 22:18:46 -0400
Date: Sun, 24 Jun 2007 19:19:05 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Adrian Bunk <bunk@stusta.de>
cc: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin LaHaise <bcrl@kvack.org>, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
In-Reply-To: <20070625014627.GC1094@stusta.de>
Message-ID: <Pine.LNX.4.64.0706241914380.10397@asgard.lang.hm>
References: <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>
 <20070624222518.GA10398@flower.upol.cz> <1182723318.6819.5.camel@laptopd505.fenrus.org>
 <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org>
 <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org>
 <20070625004106.GA1094@stusta.de> <467F1B8D.3080507@garzik.org>
 <20070625014627.GC1094@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Adrian Bunk wrote:

> On Sun, Jun 24, 2007 at 09:34:05PM -0400, Jeff Garzik wrote:
>> Adrian Bunk wrote:
>>> The interesting questions are:
>>> Does -Os still sometimes generate faster code with gcc 4.2?
>>> If yes, why?
>>
>> Smaller code can mean fewer page faults, fewer cache invalidations, etc.
>>
>> It's not just a matter of compiler code generation, gotta look at the whole
>> picture.

the picture gets even murkier when you consider that even if neither 
option overflows the cpu cache the one that takes more space in the cache 
leaves less space in the cache for the userspacde code that the system is 
actually there to run.

> Sure, but my point is that if the kernel is considered special and the
> best optimization for the kernel is therefore between -Os and -O2, we
> should try to find this point of best optimization.
>
> This should address Arjans point that -Os might not be best choice for
> best performance (and it's actually our fault if gcc generates stupid
> but small code when we use -Os).

what can be done to find the horribly bad but small code among the "it's 
smaller and would be less efficiant if you didn't consider the cache" 
majority?

David Lang
