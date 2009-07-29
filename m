Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbZG2TJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbZG2TJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbZG2TJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:09:55 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:43419 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZG2TJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:09:55 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Regression] kdesu broken, now usb fixed in current git pull
Date: Wed, 29 Jul 2009 15:09:15 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; i686; ; )
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <200907240145.31935.rjw@sisk.pl>
 <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
 <20090724182547.GB29851@skywalker>
In-reply-to: <20090724182547.GB29851@skywalker>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907291509.15244.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 July 2009, Aneesh Kumar K.V wrote:
>On Thu, Jul 23, 2009 at 05:21:36PM -0700, Ray Lee wrote:
>> On Thu, Jul 23, 2009 at 4:45 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
>> > A recent kernel change broke kdesu (from KDE 4.2) on my test boxes.
>> >  ISTR a discussion about that, but I can't find it right now.  Any
>> > clues?
>>
>> See the thread starting here: ("possible regression with pty.c commit")
>>    http://lkml.org/lkml/2009/7/11/125
>
>I am also facing a similar problem.
>
>http://bugzilla.kernel.org/show_bug.cgi?id=13815
>
>-aneesh

I just did a git bisect reset master;git pull and built a new 2.6.31-rc4.  The 
problem with my bash script has now been resolved.  Many thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Nothing cures insomnia like the realization that it's time to get up.

