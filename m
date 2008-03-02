Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbYCBSqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbYCBSqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYCBSq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:46:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:39817 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYCBSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:46:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=P9DMbmdpj8ESXM99R9o9u1noLilPDXdrBPdFibJ4pd94aIOpA7xqnxY3LtIyCS6i8V/pwjm4H58Rjao5L05pRvWG/GEfoRwvMBAPg+LsO/LUQyepLR+jH2qaCnprTwUbz23osXVv7wz8eT2ltYI47YLHsoLWMR3dJrfRzDYcDkg=
Message-ID: <47CAF5FB.4070204@gmail.com>
Date: Sun, 02 Mar 2008 21:46:19 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] saa7146: fix sparse warnings
References: <1203616356.20345.45.camel@brick>  <47CAE50C.2000106@gmail.com> <1204481204.23005.8.camel@brick>
In-Reply-To: <1204481204.23005.8.camel@brick>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison пишет:
> On Sun, 2008-03-02 at 20:34 +0300, Dmitri Vorobiev wrote:
>> Harvey Harrison пишет:
>>>  
>>> -	if( 0 != (dev->ext)) {
>>> +	if( NULL != (dev->ext)) {
>> At the risk of looking an idiot, I'm taking a liberty to ask what is
>> the point in explicit comparison to zero in conditional operators? Is
>> it not a fundamental C idiom to write
> 
> <snip>
> 
> Yes, that's how I would have written it, but I tried to keep with the
> prevailing style in that file.  I suppose I could see an argument for
> consistency if you had a long series of if() statements to keep a
> similar style.

To me it looks that the original style in this file can be sacrificed
in favor of

1) satisfying the coding style rules of the kernel;
2) keeping with informal, but commonly known idioms of C language.

So I thought that while you're at it, you could also comb through
this file and make the checkpatch.pl script happy with it.

But this is just my very personal opinion :)

Dmitri

