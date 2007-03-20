Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXCTJfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXCTJfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbXCTJfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:35:32 -0400
Received: from main.gmane.org ([80.91.229.2]:46514 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933425AbXCTJfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:35:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
Date: Tue, 20 Mar 2007 10:35:13 +0100
Message-ID: <eto9sh$262$1@sea.gmane.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703162134.14265.rjw@sisk.pl> <1174078066.13341.279.camel@localhost.localdomain> <1174087552.13341.332.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 67.152.216.81.static.g-va.siw.siwnet.net
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> I finally found a dual core box, which survives suspend/resume without
> crashing in the middle of nowhere. Sigh, I never figured out from the
> code and the bug reports what's going on.
> 
> The observed hangs are caused by a stale state transition of the clock
> event devices, which keeps the RCU synchronization away from completion,
> when the non boot CPU is brought back up.

This didn't fix the suspend problems on my Thinkpad R60. (Sorry for
nagging - please let me know if I can assist in debugging this...)

Marcus


