Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXCUDEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXCUDEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 23:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932833AbXCUDEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 23:04:47 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:42046 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbXCUDEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 23:04:46 -0400
Date: Tue, 20 Mar 2007 23:04:43 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch 00/31] 2.6.20-stable review
In-reply-to: <46004021.7040202@linuxtv.org>
To: linux-kernel@vger.kernel.org
Cc: Michael Krufky <mkrufky@linuxtv.org>, Greg KH <gregkh@suse.de>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Message-id: <200703202304.44388.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070319213647.GB9261@kroah.com>
 <200703201559.29508.gene.heskett@gmail.com> <46004021.7040202@linuxtv.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2007, Michael Krufky wrote:
>Gene Heskett wrote:
>> On Tuesday 20 March 2007, Greg KH wrote:
>>> On Tue, Mar 20, 2007 at 01:15:02AM -0400, Gene Heskett wrote:
>>>> In any event, something tickled the monster, and its hungry.  This
>>>> is a full-stop, show-stopper AFAIAC.
>>>>
>>>> I'll cut that patch-2.6.20.4-rc1 in halves, and build 2 more test
>>>> kernels tomorrow to start a bisect if no one has any better idea
>>>> before then.
>>>
>>> I'd recommend using the quilt tree of patches to do this, it will be
>>> easier than trying to split the larger patch up into pieces by hand.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> I don't have quilt installed, and no idea how to use it if it was,
>> Greg. Even my git is now pushing a year old.
>
>Gene-
>
>quilt is a very easy tool to use...  Here is a quick run-down.
>
>#1) remove the stable -rc patch from the tree
>
>#2) install quilt
>
>#3) go to your source tree, and create a directory called "patches"
>
>#4) copy all of the patches from Greg's queue into that "patches"
> directory, including the "series" file.
>
>#5) quilt push, to apply the first patch
>    quilt push, to apply the second patch (you get the idea)
>    quilt push -a , to apply all patches in the series
>
>#6) quilt pop, to back out the most recent patch pushed in
>    quilt pop -a to back out the entire series.
>
>If a patch doesnt apply, quilt will let you know about it, and present
> you with the option to force the patch to apply.  This is highly
> unlikely to occur, since Greg has already done what needs to be done to
> make these patches apply to the source.
>
>For a better explanation, see "man quilt".  Using quilt, when you have a
> list of patches and a series file containing the merge order is *much*
> easier that a git bisection, and can help you to find the problem patch
> much quicker.
>
>I hope this helps...
>
It looks like, from the series files contents, that I grabbed the 
wrong 'queue', its all 2.6.21 stuff.  url please.

Thanks.

>Good Luck,
>
>Michael Krufky



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"You show me an American who can keep his mouth shut and I'll eat him."
-- Newspaperman from Frank Capra's _Meet_John_Doe_
