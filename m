Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYGBOAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYGBOAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYGBOAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:00:05 -0400
Received: from il.qumranet.com ([212.179.150.194]:34177 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYGBOAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:00:04 -0400
Message-ID: <486B89E1.7060800@qumranet.com>
Date: Wed, 02 Jul 2008 17:00:01 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [-mmotm] some different buliding failures
References: <486B1EE0.9060303@cn.fujitsu.com> <20080702040127.779a25c5.akpm@linux-foundation.org> <486B6B0E.7090503@qumranet.com> <Pine.LNX.4.64.0807021312220.23201@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0807021312220.23201@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 2 Jul 2008, Avi Kivity wrote:
>   
>> I'm sure you have before, but can you remind me how to figure out what commit
>> to apply mmotm onto?  I looked in series and origin.patch, but no luck.
>> Applying on top of the last (first) commit in origin.patch's head did not
>> work.
>>     
>
> I look at its mm.patch, which today shows
>
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 26
> -EXTRAVERSION = -rc8
> +EXTRAVERSION = -rc8-mm1
>
> which hints that it applies to a 2.6.26-rc8 tree.
>
>   

Thanks.  That worked.

>> Also, can I suggest including series in b-o.tar.gz?
>> Nice to have everything in one tarball.
>>     
>
> It is included, but (I can't tell you why) one level up.
> You should find these three in the directory you extracted
> into, I promptly move them down into broken-out itself.
>
> .DATE
> .DATE=2008-07-02-04-02
> series
>
> Hugh (probably _not_ extracted into your current directory ;)
>   

Thanks 2.

Anyway I've fixed the warnings and will push out the fix shortly.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

