Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYJVEPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYJVEPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYJVEPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:15:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:10767 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYJVEPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=dvpDh3MTWc6hh5aZsru5+ifhL8wOX76epb7TkeZTYNsiszB4ubfqlxDjUUzAX+hDxg
         oV32hGK4GOpz59GrRWRR6BzMQQ+31b85maIJykAKiWDfXOmSRdWR318Vbhk5k7nfTYuF
         2VTl3skMzx+yKeryQSf6GzrYXUFMDxA/OmgZ0=
From: Grant Coady <gcoady.lk@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alex Howells <alex@bytemark.co.uk>, Greg KH <greg@kroah.com>,
       Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
       "H. Peter Anvin" <hpa@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Wed, 22 Oct 2008 15:15:01 +1100
Organization: scattered
Message-ID: <i0atf498dl3jeekrptbnlq0eu5h3ggdcb6@4ax.com>
References: <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com> <48F98DE2.8030205@kernel.org> <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br> <48FCD421.2010208@bytemark.co.uk> <20081020202147.GA20788@kroah.com> <48FE32E2.5000601@bytemark.co.uk> <33098.1224636084@turing-police.cc.vt.edu>
In-Reply-To: <33098.1224636084@turing-police.cc.vt.edu>
X-Mailer: Forte Agent 4.2/32.1118
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 20:41:24 -0400, you wrote:

>On Tue, 21 Oct 2008 20:52:02 BST, Alex Howells said:
>> Requirements for me to put a kernel on a given server would be:
>
>>     *  supports the hardware
>The problem is that "supports" is often a fuzzy jello-like substance you
>try to nail to a tree.  You mention the R8169 and e1000 drivers - if they
>bring the device up, but have issues under corner cases, is that "supports"
>or not?
>
>>     *  no security holes [in options I enable]
>Similarly for "no security holes".  At *BEST*, you'll get "no *known* *major*
>security holes", unless you feel like auditing the entire source tree.  There's
>a whole slew of bugs that we can't even agree if they *are* security bugs or
>just plain bugs - see Linus's rant on the subject a few months back.
>
>>     *  works reliably, under load/stress.
>And you win the trifecta - I don't think we've *ever* shipped a Linux kernel
>that worked reliably under the proper "beat on the scheduler/VM corner case"
>load/stress testing.  Again, the best you can hope for is "doesn't fall over
>under non-pathological non-corner-case loads when sufficient resources are
>available so the kernel has a fighting chance".

>...  Doing 'make -j100' on a
>single Core2 Duo is gonna be painful, no matter what.

Not painful at all, make -j100 is four seconds faster than a make -j5 on 
a Core2Duo here with slamd64-12.1 (real: 3m21 vs 3m21).

Grant.
-- 
http://bugsplatter.id.au
