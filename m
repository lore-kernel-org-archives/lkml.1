Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbYBVRuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbYBVRuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761856AbYBVRsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:48:08 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:64171 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760397AbYBVRsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:48:03 -0500
Date: Fri, 22 Feb 2008 12:47:47 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.24.1
In-reply-to: <20080222100223.GA4711@1wt.eu>
To: Willy Tarreau <w@1wt.eu>
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802221247.48178.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <479A83DE.8020002@davidnewall.com>
 <47BE267E.3070508@davidnewall.com> <20080222100223.GA4711@1wt.eu>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008, Willy Tarreau wrote:
>On Fri, Feb 22, 2008 at 12:03:50PM +1030, David Newall wrote:
>> Greg KH wrote:
>> > On Thu, Feb 21, 2008 at 10:00:58PM +0100, Willy Tarreau wrote:
>> >> I too agree to merge, it especially since it fixed several problems
>> >> for David. However, I would like to know first if the same problems
>> >> also happen with the 2.6 driver or if it is OK. The risk is getting
>> >> 2.4 fixed and not 2.6, which could cause regressions for people
>> >> upgrading from 2.4 to 2.6. Of course, a regression on a USB-serial
>> >> adapter is not dramatic, but it's a general principle to keep in mind
>> >> that 2.6 should be safe (or at least actively being fixed) when merging
>> >> driver changes in 2.4.
>> >
>> > As far as I can tell, this was a backport of the current 2.6 driver, so
>> > it should not have fixes that are not already in 2.6.
>> >
>> > David, is that true?
>>
>> That is true.
>
>OK that's perfect. I will merge it.
>
>Cheers,
>Willy

I was not successfull at testing it last night, even locally built versions of 
roadnav are segfaulting for me now.  Something still missing from the wxGTK 
camp I believe.

Feb 21 21:05:49 coyote kernel: [799800.925900] roadnav[30556]: segfault at 
00000041 eip 494b9d2f esp bf9d8570 error 4

But that may was well be swahili to me.  And it may run half an hour before it 
does it.  It seems to be related to trying to pull missing TIGER-line maps.  
Its also a serious cpu hog when its running.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
If the rich could pay the poor to die for them, what a living the poor
could make!
