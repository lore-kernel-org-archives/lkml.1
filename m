Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbXFYHQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbXFYHQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXFYHQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:16:18 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:48153
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbXFYHQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:16:17 -0400
Date: Mon, 25 Jun 2007 00:15:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Segher Boessenkool <segher@kernel.crashing.org>
cc: Willy Tarreau <w@1wt.eu>, Benjamin LaHaise <bcrl@kvack.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@stusta.de>, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>
Subject: Re: -Os versus -O2
In-Reply-To: <e6d26e7ee86cc527095de2716f285aff@kernel.crashing.org>
Message-ID: <Pine.LNX.4.64.0706250013520.6215@asgard.lang.hm>
References: <1182723318.6819.5.camel@laptopd505.fenrus.org>
 <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org>
 <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org>
 <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm>
 <1182734240.26621.2.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm>
 <20070625050424.GZ943@1wt.eu> <e6d26e7ee86cc527095de2716f285aff@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Segher Boessenkool wrote:

>>  In my experience, -Os produced faster code on gcc-2.95 than -O2 or -O3.
>
> On what CPU?  The effect of different optimisations varies
> hugely between different CPUs (and architectures).
>
>>  It was not only because of cache considerations, but because gcc used
>>  different tricks to avoid poor optimizations, and at the end, the CPU
>>  ended executing the alternative code faster.
>
> -Os is "as fast as you can without bloating the code size",
> so that is the expected result for CPUs that don't need
> special hand-holding around certain performance pitfalls.

this sounds like you are saying that people wanting performance should 
pick -Os.

what should people pick who care more about code size then anything else? 
(examples being embedded development where you may be willing to sacrafice 
speed to avoid having to add additional chips to the design)

David Lang
