Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbYA2EIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbYA2EIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYA2EHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:07:54 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:38733 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYA2EHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:07:53 -0500
Date: Mon, 28 Jan 2008 23:07:43 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
In-reply-to: <479E9A70.6090108@rtr.ca>
To: Mark Lord <liml@rtr.ca>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Message-id: <200801282307.43585.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
 <200801281906.44892.gene.heskett@gmail.com> <479E9A70.6090108@rtr.ca>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Mark Lord wrote:
>Gene Heskett wrote:
>..
>
>> That's ok, dd seemed to do the job also.
>
>..
>
>The two programs operate entirely differently from each other,
>so it may still be worth trying the make_bad_sector utility there.
>
>dd goes through the regular kernel I/O calls,
>whereas make_bad_sector sends raw ATA commands
>directly (more or less) to the drive.
>
Humm, if it (the sector error) continues.  I'm rather convinced that was a one 
time transient item caused by doing so many hardware resets.  It has not 
repeated in subsequent stanzas of this error.  Several times it went away 
while the drives long self test was in progress, and the resets that go with 
the reboot, or one of these errors seems to stop the long test, which from my 
reading, should resume with no delay, but maybe that only applies to a 
powerdown restart, which I haven't been doing.  The last such error was about 
11 hours ago now. I just started another long test, which if ok, should clear 
the stuff its showing now because the test was interrupted.  It has passed 
that test twice before in the last 36 hours.

Thanks Mark.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
You are a fluke of the universe; you have no right to be here.
