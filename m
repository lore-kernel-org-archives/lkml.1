Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYIWV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYIWV31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYIWV3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:29:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55302 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYIWV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=D+0TKQwKHT34CAPIdEaiGSpOXFp575O30rEtSpe9+eKCE66hhuNzEtG+pZtK3c0bEb
         uZOjZEr2AcZSFNXSz3nGBwg/Tq77ed9cNAYonSFLJd5mF6RNzYZ+XqnJeNMY+eciGLQF
         fYz7Ubt1XgFgd42nSL6BRctv8wDzWB2BxkkC8=
Date: Wed, 24 Sep 2008 00:29:14 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com, eduard.munteanu@linux360.ro,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [ANNOUNCE] kmemtrace-user repo update
Message-ID: <20080923212914.GB5237@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

This concerns...
http://repo.or.cz/w/kmemtrace-user.git

kmemtrace-user's git repo has been update. This is the last revision
history alteration. Due to missing copyright notices and other problems,
I preferred to keep things clean.

So now you need to git-clone it again, but it will no longer be
necessary in the future. 

Changes:
- Refactored code, it's a lot cleaner now.
- It now works on 32-bit machines, or at least I hope so: it no longer
  exhibits problems when the userspace is compiled with the -m32 flag.
- We now use mmap() for almost anything.
- kmemtraced copies /proc/kallsyms, so if you want to hack on
  kmemtrace-report, you no longer need to do all stuff on a
  kmemtrace-enabled kernel.
- Probably other misc janitorial stuff.

Priority todos:
- Integrate Tom's UTT patch (thanks again). I'd first like to provide a UTT
  wrapper in the kernel to provide all those files without having to
  explicitly code things in kmemtrace.
- Make it work cross-arch (endianness etc.).

Kinda lower priority todos:
- Add timestamps. Useful to measure allocations' lifetimes in a tangible
  way.


Please take a shot at this and let me know what you think.


	Cheers,
	Eduard

