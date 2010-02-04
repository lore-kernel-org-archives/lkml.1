Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab0BDMan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 07:30:43 -0500
Received: from stinky.trash.net ([213.144.137.162]:43931 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211Ab0BDMal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 07:30:41 -0500
Message-ID: <4B6ABDEF.8090005@trash.net>
Date: Thu, 04 Feb 2010 13:30:39 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Jon Masters <jonathan@jonmasters.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
References: <1265108690.2861.118.camel@tonnant>	 <1265130426.2861.158.camel@tonnant>	 <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com>	 <1265134598.2861.191.camel@tonnant> <4B6870AF.6060109@trash.net>	 <4B6967BC.600@trash.net> <1265222289.2861.290.camel@tonnant>	 <20100203190948.GA5182@x200> <1265226227.2861.302.camel@tonnant>	 <4B6ABCB8.4080904@trash.net> <b6fcc0a1002040427n221da433n755350b4a41bbf9b@mail.gmail.com>
In-Reply-To: <b6fcc0a1002040427n221da433n755350b4a41bbf9b@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Thu, Feb 4, 2010 at 2:25 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Jon Masters wrote:
>>> On Wed, 2010-02-03 at 21:09 +0200, Alexey Dobriyan wrote:
>>>> On Wed, Feb 03, 2010 at 01:38:09PM -0500, Jon Masters wrote:
>>>>> *). Per namespace cacheing allocation (the cachep bits). We know it's
>>>>> still possible for weirdness to happen in the SLAB cache here.
>>>> Tiny race, needs reproducer.
>>> Maybe. I think it's worth fixing anyway.
>> Absolutely, I'll also apply Eric's patch with the %p fix for the
>> slab name.
> 
> This would show kernel pointers in userspace ;-)
> So, net->id is required.

I don't see the problem. But yes, it would be nicer to have an ID.
