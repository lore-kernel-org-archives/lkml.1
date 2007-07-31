Return-Path: <linux-kernel-owner+w=401wt.eu-S967083AbXGaD5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967083AbXGaD5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965669AbXGaD45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:56:57 -0400
Received: from kludge.physics.uiowa.edu ([128.255.33.129]:47531 "EHLO
	kludge.physics.uiowa.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965102AbXGaD44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:56:56 -0400
Date: Mon, 30 Jul 2007 22:56:27 -0500
From: Joseph Pingenot <trelane@digitasaru.net>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070731035626.GG6812@digitasaru.net>
Reply-To: trelane@digitasaru.net
Mail-Followup-To: Al Viro <viro@ftp.linux.org.uk>,
	linux-kernel@vger.kernel.org
References: <20070731021615.GB6812@digitasaru.net> <20070731031720.GF21089@ftp.linux.org.uk> <20070731032521.GD6812@digitasaru.net> <20070731033113.GE6812@digitasaru.net> <20070731033631.GH21089@ftp.linux.org.uk> <20070731034059.GF6812@digitasaru.net> <20070731035023.GI21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731035023.GI21089@ftp.linux.org.uk>
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
>On Mon, Jul 30, 2007 at 10:40:59PM -0500, Joseph Pingenot wrote:
>> I'm trying to implement pwait.  It blocks until a specified PID exits,
>>   and then it exits.
>er... ptrace(2)?

Should work for most common usage scenarios, although will suspect that it
  won't for for processes owned by another user (at least, I hope
  it wouldn't).

What is dangerous about inotify on a proc file?

-- 
trelane@digitasaru.net.///////////////////////////////////////////////
"There is also an entire branch in the physical therapy field dedicated
 to the treatment of little-finger injuries caused by excessive Emacs
 use."  --Linux Weekly News editor (http://lwn.net/Articles/206916/)
///////260 IATL / The University of Iowa / Iowa City, IA  52242///////
