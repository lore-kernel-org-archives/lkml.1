Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbZJWH5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbZJWH5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZJWH5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:57:15 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:47349 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZJWH5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=D1k+dZpZp6y/avSmmcaGNpku9S+1sWKHWqNFZFYcmIRxvj2hwlT9utzgOTD8erk8Ll
         KjQHuLKXnnhW4RANNY/8rN4NhuL58BhwmtPTbftg/2Jj1zktfiX+SqiiJFWlpHUfEVuA
         +EWD7Zp1qXpgJ02Ub/csjtNjUg6yCfaepM6dI=
MIME-Version: 1.0
In-Reply-To: <20091023052052.GA15499@elf.ucw.cz>
References: <20091019213751.GC1482@ucw.cz> <f17812d70910211320s29d3aaa5tad3206df1e99e03b@mail.gmail.com> 
	<1256251399.23211.164.camel@dax.rpnet.com> <20091023052052.GA15499@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 23 Oct 2009 15:56:59 +0800
Message-ID: <f17812d70910230056y3d1fca0enc821f9ef46f07145@mail.gmail.com>
Subject: Re: spitz backlight: fix brightness limiting
To: Pavel Machek <pavel@ucw.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>, Andrew Morton <akpm@osdl.org>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 1:20 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2009-10-22 23:43:19, Richard Purdie wrote:
>> On Thu, 2009-10-22 at 04:20 +0800, Eric Miao wrote:
>> > It's a little bit weird it's called 'limit_mask' when I first converted it
>> > to a spi driver. There must be some reasons, Richard, you've got
>> > any ideas?
>>
>> Its a historical artifact that once worked through some bitfield magic
>> but probably stopped working when we increased the range of values the
>> backlight could accept and we didn't notice the limiting problem.
>>
>> I'll happily take a patch to fix that.
>
> Patch is available in the parent post. For now, I just fix it so that
> it does not turn backlight off when it should not. I'll submit
> limit_mask -> limit as separate patch, ok?

I'm fine with that. Feel free to.
