Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZC0DlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZC0DlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbZC0DlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:41:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbZC0DlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:41:14 -0400
Date: Thu, 26 Mar 2009 20:38:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090326182519.d576d703.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0903262035270.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
 <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Andrew Morton wrote:
> 
> Why does everyone just sit around waiting for the kernel to put a new
> value into two magic numbers which userspace scripts could have set?
> 
> My /etc/rc.local has been tweaking dirty_ratio, dirty_background_ratio
> and swappiness for many years.  I guess I'm just incredibly advanced.

.. and as a result you're also testing something that nobody else is.

Look at the complaints from people about fsync behavior that Ted says he 
cannot see. Let me guess: it's because Ted probably has tweaked his 
environment, because he is advanced. As a result, other people see 
problems, he does not.

That's not "advanced". That's totally f*cking broken.

Having different distributions tweak all those tweakables is just even 
_more_ so. It's the anti-thesis of "advanced". It's just stupid.

We should aim to get it right. The "user space can tweak any numbers they 
want" is ALWAYS THE WRONG ANSWER. It's a cop-out, but more importantly, 
it's a cop-out that doesn't even work, and that just results in everybody 
having different setups. Then nobody is happy.

		Linus

