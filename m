Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbXGKSCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbXGKSCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbXGKSB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:01:57 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:55179
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXGKSB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:01:56 -0400
Date: Wed, 11 Jul 2007 10:55:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, a1426z@gawab.com,
       jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Hibernation Redesign
In-Reply-To: <200707112211.23420.nigel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.64.0707111052380.25614@asgard.lang.hm>
References: <200707081737.21932.a1426z@gawab.com> <200707111304.40504.rjw@sisk.pl>
 <E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu> <200707112211.23420.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Nigel Cunningham wrote:

> Hi.
>
> On Wednesday 11 July 2007 21:11:34 Miklos Szeredi wrote:
>>> Anyway, to implement the kexec approach we must separate the
>>> hibernation from the suspend at the drivers level, which I'm still
>>> going to do, but I need to take part in endless discussions
>>
>> Discussions are good.  We understand the problem better.  Now I still
>> think we don't understand every aspect completely, so continuing the
>> discussion makes sense.
>>
>>> regarding the freezer, how it is bad and how we should drop it,
>>> because it breaks things (which NB is not true, because it doesn't).
>>
>> This thread started out from a bug, that seemed to be caused by the
>> freezer (we still don't exactly know what it was caused by), and the
>> discussion uncovered various problems _with_ the freezer, that up to
>> now no other _proper_ solutions have been propsed than to remove the
>> freezer.
>
> No other _proper_ solutions have been proposed. Everyone who suggests removing
> the freezer also suggests implementing it all over again. It might be sending
> SIGSTOP to everything. It might be shifting the desk chairs around and
> creating a completely new kernel context, but they always have the same
> goal - stopping the existing activity, and they all come with their own
> issues (even if they're not obvious yet because the alternatives are
> currently vapourware to one extent or another).

I think the big problem with the existing freezer is that you want to stop 
everything, except X, except Y, except Z.....

the advantage of the new approaches being proposed is that they don't 
require _anything_ from the origional system continue to run so you avoid 
all the exceptions.

freezing everything is easy, figuring out what you don't want to freeze is 
where everyone is seeing problems.

> IMHO, the real solution is to go back to the original issue and fix it
> properly. Make fuse filesystems play nicely with the existing freezer. I've
> just gone back and looked at the point where you started talking
> about "malicious filesystems". You talk about fuse imposing certain ordering
> in the userspace tasks being frozen. Please, say more. What ordering issues?
> Why? How can such ordering be determined programmatically?

I think most people just see this as a symptom of the problem, not the 
core problem itself.

David Lang
