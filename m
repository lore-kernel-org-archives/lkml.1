Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbXCUC4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbXCUC4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 22:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbXCUC4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 22:56:24 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:53745 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbXCUC4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 22:56:23 -0400
Date: Tue, 20 Mar 2007 22:56:09 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch 00/31] 2.6.20-stable review
In-reply-to: <46004021.7040202@linuxtv.org>
To: linux-kernel@vger.kernel.org
Message-id: <200703202256.09151.gene.heskett@gmail.com>
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

I hope by Greg's queue you meant:

<ftp:ftp.kernel.org:/pub/linux/kernel/people/gregkh/gregkh-2.6/patches>
As that's the tree I just pulled in and put in /usr/src/patches with gftp.

>#5) quilt push, to apply the first patch
>    quilt push, to apply the second patch (you get the idea)
>    quilt push -a , to apply all patches in the series

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

I do too, but I'm now less than 2 hours from the backup run, which with 
this currently running kernel, should be a sane one.

?  Since this will start with a patch level of a 2.6.20.3 kernel (or is 
that patch level a mistaken assumption on my part, but I haven't reversed 
the 2.6.20.4-rc1 patch yet, that's next.), and I have to edit both the 
Makefile and my 'makeit' script so the names all match, what makes a good 
naming convention while I'm doing this?  This might all be clear once I 
read the quilt manpage, which I haven't had a chance to do yet.

That is next, after I reverse that patch.

>Good Luck,
>
>Michael Krufky

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The chief cause of problems is solutions.
		-- Eric Sevareid
