Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYFWHu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYFWHu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYFWHt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:49:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42440 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYFWHt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:49:57 -0400
Date: Mon, 23 Jun 2008 09:16:01 +0200
From: Pavel Machek <pavel@suse.cz>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
Message-ID: <20080623071601.GA1553@elf.ucw.cz>
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl> <20071127053846.GA28884@srcf.ucam.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(replying to *very* old mail).

>>>> We wait until they can continue.
>>>
>>> So if I have a process blocked on an unavilable NFS mount, I can't
>>> suspend?
>>
>> That's correct, you can't.
>>
>> [And I know what you're going to say. ;-)]
>
> Why exactly does suspend/hibernation depend on "TASK_INTERRUPTIBLE" instead 
> of a zero preempt_count()?  Really what we should do is just iterate over 
> all of the actual physical devices and tell each one "Block new IO requests 
> preemptably, finish pending DMA, put the hardware in low-power mode, and 
> prepare for suspend/hibernate".  As long as each driver knows how to do 
> those simple things we can have an entirely consistent kernel image for 
> both suspend and for hibernation.

Patch would be welcome, actually. It turns out blocking new
IO-requests is not completely trivial.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
