Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYC1SF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYC1SF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYC1SFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:05:39 -0400
Received: from gw.goop.org ([64.81.55.164]:48421 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbYC1SFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:05:38 -0400
Message-ID: <47ED3357.7010608@goop.org>
Date: Fri, 28 Mar 2008 11:05:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3 of 4] sparsemem: reduce i386 PAE section size
References: <b7d0773c79887ca98d6c.1206664119@localhost>	 <Pine.LNX.4.64.0803271734450.10635@schroedinger.engr.sgi.com>	 <47EC574C.10006@goop.org>	 <Pine.LNX.4.64.0803271926520.11576@schroedinger.engr.sgi.com>	 <47EC8DD0.4090401@goop.org> <1206722599.7883.119.camel@nimitz.home.sr71.net>
In-Reply-To: <1206722599.7883.119.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
>
> Developers should probably learn the tradeoffs before they go start
> poking around in code and sending patches. ;)
>   

I don't know any better way of learning the tradeoffs than by poking 
around and sending patches ;)

> BTW, the current 1G sections were picked because all the hardware we
> knew of at the time had 512MB dimms that had to be added in pairs.  So,
> we didn't ever have physical hotplug of less than that.
>   

I guessed it was something like that.  Even for my case 1G isn't too 
bad.  It was bad when I was trying to hotplug early and it was having 
allocation failures in the bootmem allocator, but I think it should be 
OK now.  On the other hand, when you're hotplugging new memory is 
precisely when you don't want to be allocating lots of new memory...

    J
