Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbXBDOqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbXBDOqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 09:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbXBDOqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 09:46:10 -0500
Received: from mx1.suse.de ([195.135.220.2]:39873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbXBDOqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 09:46:09 -0500
From: Andi Kleen <ak@suse.de>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric_Riss?= <frederic.riss@gmail.com>
Subject: Re: 2.6.20-rc7: known regressions
Date: Sun, 4 Feb 2007 15:37:24 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Garzik <jeff@garzik.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <200702031151.17220.ak@suse.de> <1170594788.5217.4.camel@funkylaptop>
In-Reply-To: <1170594788.5217.4.camel@funkylaptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702041537.24560.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> When calling into the EFI firmware, the parameters need to be passed on
> the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
> This patch is needed to allow the new Intel-based Macs to suspend to ram
> (efi.get_time is called during the suspend phase).

Thanks looks good.

-Andi
