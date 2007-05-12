Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbXELT5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbXELT5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXELT5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:57:06 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:59385 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbXELT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:57:05 -0400
Date: Sat, 12 May 2007 20:17:24 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] "volatile considered harmful", take 3
Message-ID: <20070512191723.GA22380@gallifrey>
References: <12700.1178905000@lwn.net> <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com> <464551D5.2050709@zytor.com> <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com> <46455CD9.7010205@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46455CD9.7010205@zytor.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 20:07:59 up 8 days, 12:50,  2 users,  load average: 0.57, 0.43, 0.38
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Satyam Sharma wrote:
> > 
> > Because volatile is ill-defined? Or actually, *undefined* (well,
> > implementation-defined is as good as that)? It's *so* _vague_,
> > one doesn't _feel_ like using it at all!
> > 
> 
> Sorry, that's just utter crap.  Linux isn't written in some mythical C
> which only exists in standard document, it is written in a particular
> subset of GNU C.  "volatile" is well enough defined in that context, it
> is just frequently misused.

Where? I don't ever recall seeing something that defines Gcc's behaviour
with volatile on different architectures.
I know on some architectures gcc generates different instructions
for volatile accesses (e.g. load acquire/store release on IA64); I'd
be pleasently surprised if gcc's behaviour was consistent accross
architectures.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
