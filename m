Return-Path: <linux-kernel-owner+w=401wt.eu-S934743AbYCDXcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743AbYCDXcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935359AbYCDX07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:26:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935360AbYCDX05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:26:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
X-Fcc: ~/Mail/linus
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] freezer vs stopped or traced
In-Reply-To: Pavel Machek's message of  Tuesday, 4 March 2008 23:19:20 +0100 <20080304221920.GB7646@elf.ucw.cz>
References: <20080304042205.4DA9F2700FB@magilla.localdomain>
	<200803042302.44828.rjw@sisk.pl>
	<20080304221920.GB7646@elf.ucw.cz>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080304232616.8722127010A@magilla.localdomain>
Date: Tue,  4 Mar 2008 15:26:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm glad someone who actually understands signal code got to look at
> this ;-). The patch looks okay to me, but I can't say I'm too
> qualified in this area.
> 
> ...but this is 2.6.26 material, right?

Yes, I think that's fine.  

I tested this only to the extend of doing some pm-suspend + resume
iterations with a stopped job and seeing that job behave correctly
before and after (and no spurious re-stop).


Thanks,
Roland
