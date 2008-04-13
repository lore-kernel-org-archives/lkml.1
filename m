Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYDMTdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYDMTdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYDMTc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:32:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:4891 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYDMTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Y0yYMLKQQE5yJdpNuNaQdmPWaNt9ncRsSTh8+LaeQx7IAsus0rHKqaV+VoWJUyxoeKi1ZFVmcPB87UltgDcObD7yd5aNvie2yP9T4dXlDQ48/KMMr3x07yvJCdnsR6OYm0c+fw/VCP1g7yu3yclAi6u9Y1XBlU9L2y4xSOSw/8Y=
Message-ID: <48025FEA.7010202@gmail.com>
Date: Sun, 13 Apr 2008 23:32:58 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jesper Juhl <jesper.juhl@gmail.com>, Ben Dooks <ben@simtec.co.uk>,
       Vincent Sanders <vince@simtec.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mfd/sm501.c: #if 0 unused functions
References: <20080413181531.GD2182@cs181133002.pp.htv.fi> <9a8748490804131155g3df93ba7s9c2131a957391ee3@mail.gmail.com> <20080413190326.GB21204@cs181133002.pp.htv.fi> <9a8748490804131208o220cd763k33b74d547911a8f0@mail.gmail.com> <20080413192420.GC21204@cs181133002.pp.htv.fi>
In-Reply-To: <20080413192420.GC21204@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk пишет:
> On Sun, Apr 13, 2008 at 09:08:31PM +0200, Jesper Juhl wrote:
>> On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
>>> On Sun, Apr 13, 2008 at 08:55:21PM +0200, Jesper Juhl wrote:
>>>  > On 13/04/2008, Adrian Bunk <bunk@kernel.org> wrote:
>>>  > > This patch #if 0's the following unused functions:
>>>  > >  - sm501_find_clock()
>>>  > >  - sm501_gpio_get()
>>>  > >  - sm501_gpio_set()
>>>  > >
>>>  >
>>>  > Hi Adrian,
>>>  >
>>>  > I know we've discussed this before, but I have to comment on this once more.
>>>  >
>>>  > Why is it that you seem to prefer adding '#if 0' around blocks of
>>>  > unused code instead of removing it outright?
>>>
>>>> ...
>>>  When I removed unused code outright some people complained that they
>>>  plan to use it tomorrow or in the next millenium or whenever.
>>>
>>>  When I #if 0 it other people complain that I should remove it outright.
>>>
>>>  So whatever I do, there's always someone complaining.  ;-)
>>>
>>>  In this case the code looks as if it might get used at some point in the
>>>  future.
>>>
>>>  But if a maintainer tells me to resend a patch with the code removed
>>>  instead of #if 0'ed I'm always glad to do this.
>>>
>> But, you are completely ignoring the case of "the code is unused, but
>> will probably be used soon, so I'll just leave it alone and avoid the
>> churn".  Why? What's the point of commenting it out now and then
>> enabling it again in a month or two - isn't that just pointless churn?
>> ...
> 
> It's unused since more than one year, so chances are it won't get used 
> in a month or two.
> 
> As I said, if a maintainer wants me to remove it outright I'll be glad 
> to do so.
> 
> And as I said, no matter whatever I do, there's always someone 
> complaining...

It appears to me that if you had complaint statistics, that would have
provided a solid ground for choosing the right strategy for dead code.
Offhand, I have a feeling that the fraction of cases when the code that
has been abandoned long ago is about to be reused in near future ought
to be small.

Thanks,
Dmitri

> 
> cu
> Adrian
> 

