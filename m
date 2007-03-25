Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbXCYTmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbXCYTmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXCYTmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:42:11 -0400
Received: from www.osadl.org ([213.239.205.134]:51913 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752195AbXCYTmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:42:10 -0400
Subject: Re: [BUG] __copy_to_user_inatomic broken on non Pentium machines
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stable Kernel Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org>
References: <1174810024.10840.477.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703251039170.6730@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 21:41:11 +0200
Message-Id: <1174851671.3892.2.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 11:14 -0700, Linus Torvalds wrote:
> > Environment: Pre Pentium systems, (boot_cpu_data.wp_works_ok == 0)
> 
> This shouldn't be "pre-pentium", afaik. WP-works-ok on i486 too. I think 
> only the original i386 had this bug ("feature").
>
> But I agree, it does seem to be broken on such machines (I assume you 
> don't actually have one, but just tested by forcing it by hand ;)

Yes, it's a genuine i386 embedded system and AFAIK the same feature is
available on 486 clones. i386 and Co are still in used in the embedded
space.

	tglx




