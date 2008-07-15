Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbYGOFpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbYGOFpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYGOFo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:44:59 -0400
Received: from mail.lang.hm ([64.81.33.126]:37538 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbYGOFo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:44:58 -0400
Date: Mon, 14 Jul 2008 22:45:21 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: David Woodhouse <dwmw2@infradead.org>
cc: Arjan van de Ven <arjan@infradead.org>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, rene.herman@keyaccess.nl,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
In-Reply-To: <1216098546.27455.190.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.1.10.0807142241040.6370@asgard>
References: <487C0A12.9060906@keyaccess.nl>  <20080714.192425.241878700.davem@davemloft.net>  <alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>  <20080714.194557.78177585.davem@davemloft.net>  <20080714215648.1ed29448@infradead.org>
 <1216098546.27455.190.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, David Woodhouse wrote:

> On Mon, 2008-07-14 at 21:56 -0700, Arjan van de Ven wrote:
>> On Mon, 14 Jul 2008 19:45:57 -0700 (PDT)
>> David Miller <davem@davemloft.net> wrote:
>>
>>> From: Linus Torvalds <torvalds@linux-foundation.org>
>>> Date: Mon, 14 Jul 2008 19:39:03 -0700 (PDT)
>>>
>>>> Put this way: if you do a distro, you _need_ to support firmware
>>>> loading anyway. And once you do that, it's just annoying how some
>>>> drivers then do something odd and special for the same thing, for
>>>> no real good reason.
>>>
>>> In what way is it annoying?
>>>
>>> Most distribution people aren't even aware that drivers like tg3 and
>>> bnx2 even have firmware.  In fact it's self contained and less for
>>> them to worry about.
>>
>> and.. after this patch that still seems to be the case, unless I'm
>> looking at it really cross eyed.
>> Nothing in this patch makes it impossible to do so.. or changes the
>> drivers you mention.
>
> Well, the HEAD of my tree (and linux-next) does change tg3. I just
> haven't asked Linus to pull that part, because I wanted to keep the
> contentious part separate from the simple and obvious parts.
>
> (Even though the tg3 fix _is_ simple and obvious, to me. But that
> evidently doesn't stop it from being contentious too. So it can wait.)

a techinical question here (I know, how dare I ask a technical question in 
the middle of the flamefest ;-)

linus pointed out that the documentation reccomended the
request_firmware();load_firmware();release() approach and stated that that 
approach was the wrong way to do things, instead doing a request_firmware 
early and release when the module is unloaded.

does this patch series follow the documented reccomendation? or does it 
follow the more concervative approach Linus pointed out? (it's far faster 
to ask then to search Internet archives for the patches)

David Lang
