Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZL2Prl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZL2Prl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZL2Prj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:47:39 -0500
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:58091 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbZL2Prh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:47:37 -0500
Message-ID: <4B3A2497.1030506@gmail.com>
Date: Tue, 29 Dec 2009 16:47:35 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091210 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Reported regressions 2.6.31 -> 2.6.32
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Dec 2009 15:47:35.0808 (UTC) FILETIME=[3DE49000:01CA889E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 12/29/09 16:26, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14896
> Subject		: REGRESSION for RT2561/RT61 in 2.6.32, related to power saving
> Submitter	: Alan Stern <stern@rowland.harvard.edu>
> Date		: 2009-12-06 22:12 (24 days old)
> References	: http://marc.info/?l=linux-kernel&m=126013756829691&w=4
> Handled-By	: Gertjan van Wingerde <gwingerde@gmail.com>
> 

This one is fixed via a patch that is queued to be merged into 2.6.33. Is submitted
for stable as well.
See http://marc.info/?l=linux-wireless&m=126090994909576&w=2

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14731
> Subject		: rt61pci regression
> Submitter	: tim blechmann <tim@klingt.org>
> Date		: 2009-12-04 09:33 (26 days old)
> 

I believe this problem to be the same as the previous one, and the fix indicated above
should fix this as well.
Note however that the submitter had presumably unrelated issues that caused him not to 
be able to validate the workaround of disabling powersaving.

---
Gertjan.

