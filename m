Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZGPPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZGPPOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757661AbZGPPOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:14:17 -0400
Received: from lucidpixels.com ([75.144.35.66]:42098 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651AbZGPPOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:14:16 -0400
Date: Thu, 16 Jul 2009 11:14:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: David Rientjes <rientjes@google.com>
cc: Stephan von Krawczynski <skraw@ithnet.com>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: What to do with this message (2.6.30.1) ?
In-Reply-To: <alpine.DEB.2.00.0907151323170.22582@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0907161113440.1116@p34.internal.lan>
References: <20090713134621.124aa18e.skraw@ithnet.com> <4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com> <alpine.DEB.2.00.0907132247001.8784@chino.kir.corp.google.com> <20090715084754.36ff73bf.skraw@ithnet.com> <alpine.DEB.2.00.0907150115190.14393@chino.kir.corp.google.com>
 <20090715113740.334309dd.skraw@ithnet.com> <alpine.DEB.2.00.0907151323170.22582@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Jul 2009, David Rientjes wrote:

> On Wed, 15 Jul 2009, Stephan von Krawczynski wrote:
>
>>> If you have some additional time, it would also be helpful to get a
>>> bisection of when the problem started occurring (it appears to be sometime
>>> between 2.6.29 and 2.6.30).
>>
>> Do you know what version should definitely be not affected? I can check one
>> kernel version per day, can you name a list which versions to check out?
>>
>
> To my knowledge, this issue was never reported on 2.6.29, so that should
> be a sane starting point.
>

After talking to Stephan offline--

I am also using the Intel e1000e for my primary network interface to the
LAN, I suppose this is the culprit?  I have both options compiled in e1000
and e1000e as I have Intel 1Gbps PCI nics as well.. I am thinking back now
and before the introduction of e1000e I do not recall seeing any issues,
perhaps this is it?

Justin.



