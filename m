Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbXLZTBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbXLZTBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 14:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXLZTBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 14:01:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50489 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751001AbXLZTBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 14:01:01 -0500
Date: Wed, 26 Dec 2007 20:00:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20071226190045.GB8094@elf.ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <4772A3FB.8080108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4772A3FB.8080108@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-12-26 10:56:59, H. Peter Anvin wrote:
> Pavel Machek wrote:
>> This is RFC. It does not even work for me... it sleeps but it will not
>> wake up, because SATA wakeup code is missing. Code attached for 
>> illustration.
>> I wonder if this is the right approach? What is right interface to the
>> drivers?
>> 3) Network card that is either down
>>    or can wake up system on any packet (and not loose too many packets)
>
> This is the big crux I see.  You're going to constantly wake up the machine 
> due to broadcast packets, and spend a lot of power just going in and out of 
> S3.

Yep... for the first version, I'll be very happy if it autosleeps when
I'm traveling by bus or something. Working with ethernet plugged in is
quite a distant goal.

(But I guess some cleverness could be done on the router or
something. Automagically converting "interesting" packets into WoL
enabled ones, or...?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
