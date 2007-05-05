Return-Path: <linux-kernel-owner+w=401wt.eu-S1423346AbXEEBUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423346AbXEEBUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161630AbXEEBUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:20:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161615AbXEEBUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:20:05 -0400
Date: Fri, 4 May 2007 18:19:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dtor@insightbb.com>, Greg KH <gregkh@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input patches for 2.6.20
In-Reply-To: <200705030107.44990.dtor@insightbb.com>
Message-ID: <alpine.LFD.0.98.0705041806210.3808@woody.linux-foundation.org>
References: <200702180204.48643.dtor@insightbb.com>
 <200705030107.44990.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1215937223-1178327228=:3808"
Content-ID: <alpine.LFD.0.98.0705041807160.3808@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1215937223-1178327228=:3808
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.0.98.0705041807161.3808@woody.linux-foundation.org>



On Thu, 3 May 2007, Dmitry Torokhov wrote:
> 
> If you have not pulled yet please pull from:
>
>         master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> because master branch will have extra stuff in the next minute or so.

Hmm. That thing had a conflict with the driver core changes I just pulled 
from Greg due to Greg removing "struct subsystem".

The conflict looked really trivial, and I fixed up the obvious places, 
probably correctly. Please verify.

Martin, in the process I noticed that the new file

	arch/s390/kernel/ipl.c

seems to be broken by the same thing after the driver core merge. The fix 
_looks_ equally trivial (change *subsys.kset.kobj into just *subsys.kobj), 
but I didn't do that trivial thing, because I cannot even test-compile the 
end result. So can you give it a quick look, please?

Greg - maybe more of a heads-up to people next time you do something like 
this? Did this removal hit -mm? Anyway, it looks like something trivial to 
fix up after, but ..

		Linus
---1463790079-1215937223-1178327228=:3808--
