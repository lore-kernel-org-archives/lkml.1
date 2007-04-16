Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbXDPDov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbXDPDov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbXDPDov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:44:51 -0400
Received: from gw.goop.org ([64.81.55.164]:49173 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXDPDou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:44:50 -0400
Message-ID: <4622F10C.1080203@goop.org>
Date: Sun, 15 Apr 2007 20:44:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [2/2] 2.6.21-rc7: known regressions
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <20070416005446.GB21217@redhat.com> <20070416011636.GO3691@stusta.de>
In-Reply-To: <20070416011636.GO3691@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> I'm not sure why I thought you two ran into the same regression.
>
> So "hpet=disable" worked for Jeremy but not for you, IOW: you two were 
> running into different regressions?
>
> @Jeremy:
> If this is true, is your HPET related related regression still present 
> in -rc7?

I need to recheck, but when I tried -rc6, I was still having resume
problems but hpet=disabled didn't help.  So I definitely think there are
multiple bugs with the same symtoms.  I haven't tried -rc7 yet.

    J
