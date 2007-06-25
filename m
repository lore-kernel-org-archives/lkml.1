Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbXFYHmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbXFYHmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXFYHl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:41:56 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:53354 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbXFYHlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:41:55 -0400
In-Reply-To: <Pine.LNX.4.64.0706250013520.6215@asgard.lang.hm>
References: <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm> <1182734240.26621.2.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm> <20070625050424.GZ943@1wt.eu> <e6d26e7ee86cc527095de2716f285aff@kernel.crashing.org> <Pine.LNX.4.64.0706250013520.6215@asgard.lang.hm>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <513fca4651d60bae8fe6a567c665893c@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
       Willy Tarreau <w@1wt.eu>, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@stusta.de>, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: -Os versus -O2
Date: Mon, 25 Jun 2007 09:41:50 +0200
To: david@lang.hm
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> -Os is "as fast as you can without bloating the code size",
>> so that is the expected result for CPUs that don't need
>> special hand-holding around certain performance pitfalls.
>
> this sounds like you are saying that people wanting performance should 
> pick -Os.

That is true on most CPUs.  Some CPUs really really need
some of things that -Os disables (compared to -O2) for
decent performance though (branch target alignment...)

> what should people pick who care more about code size then anything 
> else? (examples being embedded development where you may be willing to 
> sacrafice speed to avoid having to add additional chips to the design)

-Os and tune some options.  There is extensive work being
done over the last few years to make GCC more suitable for
embedded targets btw.  But the -O1/-O2/-O3/-Os gives you
four choices only, it's really not so hard to understand
I hope that for more specific goals you need to add more
specific options?


Segher

