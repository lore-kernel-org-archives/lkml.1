Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXGKMZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXGKMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbXGKMZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:25:19 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:59861 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677AbXGKMZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:25:18 -0400
To: nigel@nigel.suspend2.net
CC: miklos@szeredi.hu, rjw@sisk.pl, a1426z@gawab.com, jeremy@goop.org,
       jbms@cmu.edu, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <200707112211.23420.nigel@nigel.suspend2.net> (message from Nigel
	Cunningham on Wed, 11 Jul 2007 22:11:22 +1000)
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <200707111304.40504.rjw@sisk.pl> <E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu> <200707112211.23420.nigel@nigel.suspend2.net>
Message-Id: <E1I8bEi-0000HF-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 14:24:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No other _proper_ solutions have been proposed. Everyone who suggests removing 
> the freezer also suggests implementing it all over again. It might be sending 
> SIGSTOP to everything. It might be shifting the desk chairs around and 
> creating a completely new kernel context, but they always have the same 
> goal - stopping the existing activity, and they all come with their own 
> issues (even if they're not obvious yet because the alternatives are 
> currently vapourware to one extent or another).

Hey, I know precious little about drivers and power management, but I
can clarly see, that

 a) stopping all tasks and requiring them to finish any syscall they
 are in

 b) stopping tasks _in the driver_ that are trying to access the
 harware during/after suspend

are completely different solutions, the later being much more fine
grained and not having all of the mentioned problems that the former
exhibits.

> IMHO, the real solution is to go back to the original issue and fix it 
> properly. Make fuse filesystems play nicely with the existing freezer. I've 
> just gone back and looked at the point where you started talking 
> about "malicious filesystems". You talk about fuse imposing certain ordering 
> in the userspace tasks being frozen. Please, say more. What ordering issues? 
> Why? How can such ordering be determined programmatically?

It can't.  If you are interested, please read through that thread.  If
something's still not clear, let's discuss it further.

Miklos
