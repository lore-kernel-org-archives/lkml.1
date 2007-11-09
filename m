Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbXKIWzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbXKIWzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbXKIWzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:55:25 -0500
Received: from igraine.blacknight.ie ([81.17.252.25]:49034 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbXKIWzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:55:24 -0500
Date: Fri, 9 Nov 2007 22:55:04 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Jan Blunck <jblunck@suse.de>
Cc: Robert Fitzsimons <robfitz@273k.net>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Subject: Re: oops in oprofile/dump_trace/X86 with 2.6.24-rcX
Message-ID: <20071109225504.GA18210@localhost>
References: <20071108014527.GA2474@localhost> <20071109213010.GJ18693@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109213010.GJ18693@hasse.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=-1.512, required 7,
	autolearn=disabled, RCVD_IN_NERDS_IE -3.50, RCVD_IN_SORBS_DUL 1.99)
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> this only happens 32bit. Somehow I broke this when I introduced
> stack_pointer(). Here is a patch that fixes the problem.
> 
> Subject: oprofile: Fix oops on x86 32-bit

I've tested this and it fixes the oops.

Thank you.

Robert

