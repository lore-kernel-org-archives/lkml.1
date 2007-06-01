Return-Path: <linux-kernel-owner+w=401wt.eu-S1762427AbXFATC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762427AbXFATC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbXFATCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:02:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35547 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbXFATCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:02:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	<1177654110.4737.91.camel@nigel.suspend2.net>
	<Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
	<200704272324.43359.rjw@sisk.pl>
	<alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
	<463292C8.9000307@goop.org> <20070428010043.GA21136@srcf.ucam.org>
	<46329DE3.6020307@goop.org> <20070503151408.GC3866@ucw.cz>
Date: Fri, 01 Jun 2007 13:00:19 -0600
In-Reply-To: <20070503151408.GC3866@ucw.cz> (Pavel Machek's message of "Thu, 3
	May 2007 15:14:09 +0000")
Message-ID: <m1tztrzeik.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
>> > While that would certainly be nifty, I think we're arguably starting 
>> > from the wrong point here. Why are we booting a kernel, trying to poke 
>> > the hardware back into some sort of mock-quiescent state, freeing memory 
>> > and then (finally) overwriting the entire contents of RAM rather than 
>> > just doing all of this from the bootloader?
>
> Doing it from the bootloader sounds attractive... but it is lot of
> work. I'm essentially using linux as a bootloader.
>
> Patch for grub welcome.

Well.  We actually have first class support for using linux as a
bootloader.  So you could use linux and do whatever dance you are
doing from a bootloader if you felt the desire.

That might make the dance a little easier.

Eric
