Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYGUPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYGUPSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYGUPRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:17:50 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:15146 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYGUPRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:17:49 -0400
Message-ID: <4884A88D.30406@hp.com>
Date: Mon, 21 Jul 2008 11:17:33 -0400
From: jim owens <jowens@hp.com>
User-Agent: Mozilla/5.0 (X11; U; OSF1 alpha; en-US; rv:1.7.13) Gecko/20060421
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Please add ZFS support (from GPL sources)
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com>	 <487FA143.9010109@garzik.org> <20080720105724.GA8921@infradead.org>	 <d1af83620807200535s6516e3b7wd16233391e5e8533@mail.gmail.com>	 <20080721072801.GA6115@infradead.org>	 <d1af83620807210439r6b8fa39bu4f3fd76c86aa548d@mail.gmail.com>	 <f188924b0807210723v3a35de9fgc1565811a0597833@mail.gmail.com> <d1af83620807210740vfef575bp73832fd95d803850@mail.gmail.com>
In-Reply-To: <d1af83620807210740vfef575bp73832fd95d803850@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> 
> On Mon, Jul 21, 2008 at 11:23 AM, Fred . <eldmannen@gmail.com> wrote:
> 
>>On Mon, Jul 21, 2008 at 1:39 PM, Kevin Winchester
>>>
>>>No one else seems to have volunteered, so I would certainly like to
>>>give it a try.  I guess I need to get the ZFS grub code, create a ZFS
>>>filesystem, and start looking around for information on linux
>>>filesystem development and ZFS (obviously without looking at any CDDL
>>>licensed code).
>>
>>Code can be found here;
>>* http://src.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/grub/grub-0.95/stage2/
>>
>>But it may be covered by patents by Sun. So maybe not allowed make an
>>implementation. :(
>>Maybe you should consult SFLC (Software Freedom Law Center) first or something.
>>
> I would have no idea of the legal implications here.  Do I really need
> to get the lawyers involved just to use GPLv2 code from another
> project in linux?

Having just gone through open sourcing with lawyers, I would
say anything with a GPLv2 is safe. Any patent Sun has on things
released under GPLv2 is open for use.

I don't know anything about CDDL rules, but if you don't look at
it, you won't be legally contaminated.

I have not looked at the ZFS grub code, but a general warning
based on my experience with other filesystem bootstrap code
is that it may be very limited and not be able to deal with
all structures on a ZFS filesystem... you won't know until
you hit one of them and fail.

jim
