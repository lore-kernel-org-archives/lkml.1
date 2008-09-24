Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYIXTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYIXTES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYIXTED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:04:03 -0400
Received: from mail.op5.se ([193.201.96.20]:43355 "EHLO mail.op5.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYIXTEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:04:01 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2008 15:04:00 EDT
X-Spam-Flag: NO
X-Spam-Score: -3.109
Message-ID: <48DA8D76.1070207@op5.se>
Date: Wed, 24 Sep 2008 20:56:54 +0200
From: Andreas Ericsson <ae@op5.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Riesen <raa.lkml@gmail.com>
CC: rae l <crquan@gmail.com>, Matthias Urlichs <smurf@smurf.noris.de>,
       Andrew Morton <akpm@linux-foundation.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: please consider remove those tags named master, which is ambigous
 with master branch
References: <91b13c310808310948r5e9e825as27bcdf381137e179@mail.gmail.com>	 <91b13c310809230746o1c2cb694taebc814bea57c8c5@mail.gmail.com> <81b0412b0809240844y42218bedqe0e1eb22c067fcc3@mail.gmail.com>
In-Reply-To: <81b0412b0809240844y42218bedqe0e1eb22c067fcc3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Riesen wrote:
> 2008/9/23 rae l <crquan@gmail.com>:
>> To Git developers:
>>  I found that different git subcommand have inconsitent processing
>> about ambiguous refname,
>>
>> git show will take "master" tag first,
>> while git tag -v will take "master" branch first,
>>
>> So what's your suggestion to fix this? Just simple remove ambiguous refnames?
> 
> You can use "refs/tags/master" and "refs/heads/master"...

Apart from that..

"git tag -v" taking a branch *at all* is not something we want to
happen, as it's supposed to verify the pgp signature of a signed
tag. Are you absolutely 100% certain that "git tag -v" tries to
verify refs/heads/master as a tag object?

-- 
Andreas Ericsson                   andreas.ericsson@op5.se
OP5 AB                             www.op5.se
Tel: +46 8-230225                  Fax: +46 8-230231
