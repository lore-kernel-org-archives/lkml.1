Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYBENYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYBENYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYBENXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:23:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:33141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbYBENXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:23:52 -0500
Date: Tue, 5 Feb 2008 14:23:50 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: locking api self-test hanging
Message-ID: <20080205132350.GB31523@suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org,
	Stephen Hemminger <shemminger@linux-foundation.org>
References: <20080203150246.50647fa4.akpm@linux-foundation.org> <20080203150744.cf7d0415.akpm@linux-foundation.org> <20080204044304.d244e761.akpm@linux-foundation.org> <20080204050421.0febc754.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204050421.0febc754.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2008-02-04 14:04]:
> 
> but that code really needs help.

Using spin_lock_irqsave() is what rtc_get_rtc_time() does which was
used before I changed to get_rtc_time() does. So it should be ok. I
missed that difference. However, I agree with you the whole RTC
"emulation" per HPET is a bit unclean. However, I have too little
experience in this code area to come up with a proper redesign. I just
ported it from the old RTC to the new RTC module interface.

> Bernhard, I believe the checklist items in Documentation/SubmitChecklist
> would have prevented this at the source.

Yes. I must admit that I didn't know that document. I used
checkpatch.pl, but that's of course only for coding style. I'll try to
follow the points in SubmitChecklist in future.



        Bernhard
