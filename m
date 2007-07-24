Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbXGXUQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbXGXUQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763555AbXGXUQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:16:23 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39118
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763414AbXGXUQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:16:22 -0400
Date: Tue, 24 Jul 2007 13:14:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Power Management framework proposal
In-Reply-To: <1185229405.5439.148.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707241313580.6590@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm> 
 <1185125189.2714.13.camel@laptopd505.fenrus.org> <1185229405.5439.148.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Benjamin Herrenschmidt wrote:

> On Sun, 2007-07-22 at 10:26 -0700, Arjan van de Ven wrote:
>> On Sat, 2007-07-21 at 23:49 -0700, david@lang.hm wrote:
>>
>>> this approach would allow the transition of ALL drivers to the new mode of
>>> operation in one fell swoop, and then adding additional power management
>>> features is just adding to the existing list rather then implementing new
>>> functions.
>>
>>
>> I have a concern with this approach though. It seems to assume that
>> there is one global thing somewhere that sets the system state; in my
>> experience that is the wrong approach; in fact there is a very definite
>> evidence that there are many decisions on power that are to be made
>> local at a high frequency. An example of this is the processor speed;
>> the ondemand governer does exactly this for the cpus that can switch
>> speeds fast; it's just impossible to beat such a local, fast decision
>> with anything on a global scale.
>>
>> On the other hand, some things (the high level goals and constraints)
>> are obviously global.
>
> I think we need a set of constraints that trickle down the power tree
> and limit what a given driver can do locally.

what sort of contraints are you thinking of?

David Lang
