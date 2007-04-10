Return-Path: <linux-kernel-owner+w=401wt.eu-S1031244AbXDJRbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031244AbXDJRbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031242AbXDJRbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:31:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6959 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031210AbXDJRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:31:07 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Tue, 10 Apr 2007 19:31:10 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: prevent auto select of mwait_idle for AMD
 CPUs
Message-ID: <20070410173110.GB12476@alberich.amd.com>
References: <20070410172425.GE24680@alberich.amd.com>
MIME-Version: 1.0
In-Reply-To: <20070410172425.GE24680@alberich.amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Apr 2007 17:30:41.0523 (UTC)
 FILETIME=[F6424430:01C77B95]
X-WSS-ID: 6A05164F3283679603-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Actually I have also written patches to clear the MWAIT flag
for AMD CPUs.

But after re-reading of specs (also Intel's specs) I preferred
to keep the MWAIT flag but to introduce a MWAIT_NO_CSTATE flag.

I think this is the cleaner solution.


Regards,

Andreas



