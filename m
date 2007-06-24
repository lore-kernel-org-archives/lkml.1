Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbXFXKom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbXFXKom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 06:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXFXKof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 06:44:35 -0400
Received: from barikada.upol.cz ([158.194.242.200]:58423 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbXFXKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 06:44:34 -0400
Date: Sun, 24 Jun 2007 12:57:16 +0200
To: "Jay L. T. Cornwall" <jay@esuna.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: (Last oops is Tainted: P) Re: 2.6.22-rc5: pdflush oops under heavy disk load
Message-ID: <20070624105716.GA21128@flower.upol.cz>
References: <467B12CA.5060405@esuna.co.uk> <467BE118.4090308@redhat.com> <467BE4F1.7040308@esuna.co.uk> <467D0EB0.9030100@esuna.co.uk> <20070623102318.1b4f3d24.akpm@linux-foundation.org> <E1I2OqK-0005VK-JF@flower> <467E4301.2010009@esuna.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467E4301.2010009@esuna.co.uk>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 11:10:09AM +0100, Jay L. T. Cornwall wrote:
> Oleg Verych wrote:
> 
> >> That sounds like a good theory: you're getting easily-hit oopses in one of
> >> the kernel's most-used codepaths which hasn't chanbged much in a long
> >> time.  So Something Odd Has Happened.
> 
> > Maybe this time it's just "Tainted: P"?
> 
> That'sthe NVIDIA module, which isn't doing much with X shut down
> regardless. It was bad form to forget this, of course, but is unrelated
> to the problem.
> 
> > And oops have no ext3, like prev. one.
> 
> I know. This isn't ext3 related and I'm fairly certain drivers/net/atl1
> is trashing... something. Perhaps the page table because:

Last oops log was with tainting (as subject reflects), before that i've
saw ext3 and "run fsck" reply. Thus, really clean oops log with all
details, not that you have just posted may be useful.

> [  153.785325] Bad page state in process 'scp'
> [  153.785327] page:ffff81000308d020 flags:0x0040ad41dc050845
> mapping:53dfe57d17cc59cf mapcount:16885953 count:292554304
> [  153.785329] Trying to fix it up, but a reboot is needed
> 
> This one dismisses a reference counting issue because the page data here
> looks like garbage. And a panic in VLC, playing a video across the
> network hits a similar problem:

OK, i see now you are in Windows now, but i will try to ask you about
making testcase using `netcat' or `curl'. If hardware is in trouble,
probably network stressing could trigger that. And clean *one* test
script and no X (or other stuff) will surely help.

[ Netiquette here is being voluntary noise filter, after joining any   ]
[ thread, because reply-to-all is the way of communication in the LKML ]
____
