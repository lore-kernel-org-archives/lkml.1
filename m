Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbXCDOhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbXCDOhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXCDOhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:37:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:35024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862AbXCDOhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:37:35 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Guillaume Chazarain" <guichaz@gmail.com>
Subject: Re: [1/3] Bugfix: Don't use the TSC in sched_clock if unstable
Date: Sun, 4 Mar 2007 15:37:27 +0100
User-Agent: KMail/1.9.5
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <3d8471ca0703031341l1768fe7rccf40712e452ea09@mail.gmail.com>
In-Reply-To: <3d8471ca0703031341l1768fe7rccf40712e452ea09@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703041537.27581.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2007 22:41, Guillaume Chazarain wrote:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f9690982b8c2f9a2c65acdc113e758ec356676a3
> caused a regression by letting sched_clock use the TSC even when cpufreq
> disabled it. This caused scheduling weirdnesses.

What weirdnesses? Did you actually see any?  Hard data please.

I don't like this because right now it will effectively disable TSC use
on anything with pstate invariant TSC and using cpufreq: that is all
modern AMD systems. This is IMHO a serious bug in the timer subsystem which
I intend to fix.

Also I don't see where your instability should come from.  AFAIK 
there are only minor hickups in the result which shouldn't be a problem IMHO.

-Andi
