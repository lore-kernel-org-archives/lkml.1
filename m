Return-Path: <linux-kernel-owner+w=401wt.eu-S935542AbXGYTSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935542AbXGYTSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761764AbXGYTS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:18:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761726AbXGYTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:18:26 -0400
Message-ID: <46A7A1EF.8060307@zytor.com>
Date: Wed, 25 Jul 2007 12:18:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org> <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com> <20070725185328.GA28199@uranus.ravnborg.org>
In-Reply-To: <20070725185328.GA28199@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Jul 25, 2007 at 08:48:50PM +0200, Michal Piotrowski wrote:
>> On 25/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
>>>
>>>
>> Andi, this might be interesting for you
>>
>> make allmodconfig
>> make
>> [...]
>> WARNING: Absolute relocations present
>> Offset     Info     Type     Sym.Value Sym.Name
>> c02041b3 00705601   R_386_32 c0308aa8  _sdata
> 
> Who did spit out this warning. Can you please provide make V=1
> where we see the lines preceeding the warning.
> 
> And config please.
> 

config: "make allmodconfig"

System.map would be more interesting, especially what is at 0xc02041b3.

	-hpa
