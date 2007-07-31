Return-Path: <linux-kernel-owner+w=401wt.eu-S940266AbXGaDll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940266AbXGaDll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXGaDle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:41:34 -0400
Received: from kludge.physics.uiowa.edu ([128.255.33.129]:47136 "EHLO
	kludge.physics.uiowa.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbXGaDld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:41:33 -0400
Date: Mon, 30 Jul 2007 22:40:59 -0500
From: Joseph Pingenot <trelane@digitasaru.net>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070731034059.GF6812@digitasaru.net>
Reply-To: trelane@digitasaru.net
Mail-Followup-To: Al Viro <viro@ftp.linux.org.uk>,
	linux-kernel@vger.kernel.org
References: <20070731021615.GB6812@digitasaru.net> <20070731031720.GF21089@ftp.linux.org.uk> <20070731032521.GD6812@digitasaru.net> <20070731033113.GE6812@digitasaru.net> <20070731033631.GH21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731033631.GH21089@ftp.linux.org.uk>
X-School: University of Iowa
X-vi-or-emacs: vi *and* emacs!
X-MS-TNEF-Correlator: <AFJAUFHRUOGRESULWAOIHFEAUIOFBVHSHNRAIU.monkey@spamcentral.invalid>
X-MimeOLE: Not Produced By Microsoft MimeOLE V5.50.4522.1200
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Subject: Re: inotify and /proc/<pid>
X-SA-Exim-Version: 4.2.1 (built Thu, 26 Apr 2007 18:30:04 +0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From Al Viro on Tuesday, 31 July, 2007:
>On Mon, Jul 30, 2007 at 10:31:13PM -0500, Joseph Pingenot wrote:
>> >From Joseph Pingenot on Monday, 30 July, 2007:
>> >From Al Viro on Tuesday, 31 July, 2007:
>> >>On Mon, Jul 30, 2007 at 09:16:16PM -0500, Joseph Pingenot wrote:
>> >>> I was trying to use inotify to watch process changes (especially process
>> >>>   termination) by watching /proc/<pid>.
>> >>> Sadly, although I could see something reading various files, nothing
>> >>>   was issued when the process I was watching exited and the directory
>> >>>   went away.
>> >>> Is this intentional, or a bug?
>> >>It's a bug you intend to introduce in your program...  IOW, don't
>> >>do that.
>> >More background, please?
>> >What's the way to check for a process exiting without spinning?
>> I should also specify that the process being waited on is not a
>>   child process-it's just some other process on the system.
>Umm...  Any details on intended use?  IOW, is that "I want to write
>an utility that would wait for given PID to exit, just for the hell
>of it" or is there something you are trying to implement using that?

I'm trying to implement pwait.  It blocks until a specified PID exits,
  and then it exits.

You can use it to do other stuff after a program finishes.

While we're on the subject, is there some way to receive notification
  that some aspect of a process changes (in this case, stopping using
  CPU, but not exiting).

Thanks for the time to help me figure this out.

-Joseph

-- 
trelane@digitasaru.net.///////////////////////////////////////////////
"There is also an entire branch in the physical therapy field dedicated
 to the treatment of little-finger injuries caused by excessive Emacs
 use."  --Linux Weekly News editor (http://lwn.net/Articles/206916/)
///////260 IATL / The University of Iowa / Iowa City, IA  52242///////
