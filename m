Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbZLEWFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbZLEWFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 17:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZLEWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 17:05:47 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60549 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbZLEWFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 17:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Cwn32IRQoJYgK4NFo4StPh+ua7GjR7Y+PbkCY9Rf/IEwO8wV+8dffUjMYwOJca81cO
         n2cYCBZMWFMwzU0VKhKR3/AiavdRhRbQPspfsZPtBGpNY3oQ/hp8mpgh/f5WOtT6t5Cx
         +f5sXM47sJGtSbFhCo1cZgGJ4f5R5+3Xw1oZk=
Message-ID: <4B1AD930.30300@gmail.com>
Date: Sat, 05 Dec 2009 23:05:36 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: William Allen Simpson <william.allen.simpson@gmail.com>,
       Brice Goglin <brice@myri.com>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next-2.6] drivers/net: Move && and || to end of  
 previous line
References: <1259001504.16503.79.camel@Joe-Laptop.home>	 <20091123.104130.117837098.davem@davemloft.net>	 <1259528449.29779.194.camel@Joe-Laptop.home>	 <20091129.165557.84377714.davem@davemloft.net>	 <1259863101.22783.63.camel@Joe-Laptop.home>  <4B190A29.5080905@myri.com>	 <1259947271.22783.120.camel@Joe-Laptop.home>  <4B1A557D.4080707@gmail.com> <1260035440.11126.50.camel@Joe-Laptop.home>
In-Reply-To: <1260035440.11126.50.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote, On 12/05/2009 06:50 PM:

> On Sat, 2009-12-05 at 07:43 -0500, William Allen Simpson wrote:
>> Joe Perches wrote:
>>> On Fri, 2009-12-04 at 14:10 +0100, Brice Goglin wrote:
>>>> Joe Perches wrote:
>>>>> Only files where David Miller is the primary git-signer.
>>>>> wireless, wimax, ixgbe, etc are not modified.
>>>> What's the point? Having them at the beginning of the next line is
>>>> easier to read from my point of view.
>>> It's just a stupid consistency thing.
>> Joe *agrees* that
>> having them on the beginning of the line is preferred.
> 
> This is not true.
> 
> I prefer code that I write for myself to
> use leading continuation tests.
> 
> For the Linux code, as should be obvious
> from the patches I submit, I prefer to
> have adherence to one predominant majority
> style.  I don't much care what form that
> style actually takes.
> 
>> Thousands of
>> contributors throughout the tree agree.
>> This is entirely a Miller thing.
> 
> Nope.  There have been many efforts to
> help standardize on single form styles.
> 
>> My main objection to these sweeping patches is that it makes it much
>> more difficult to maintain and apply patches across different versions of
>> the tree.
> 
> I think you underestimate the value of
> standardization and overestimate the
> quantity of work to sort it out for
> the -stable versions.

Actually, technically, legally etc. (except practically) William is right:
if it's not in the CodingStyle, and not obviously wrong, it shouldn't be
forced.

Jarek P.
