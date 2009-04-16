Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZDPU21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZDPU21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZDPU2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:28:17 -0400
Received: from rtr.ca ([76.10.145.34]:49595 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZDPU2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:28:16 -0400
Message-ID: <49E794DF.8050001@rtr.ca>
Date: Thu, 16 Apr 2009 16:28:15 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20090416193924.GA27823@havoc.gtf.org>
In-Reply-To: <20090416193924.GA27823@havoc.gtf.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Various minor fixes, and a small libata.h cleanup.
..

Any chance you could also push out the last of the sata_mv errata workarounds?
That's the one that prevents data corruption for multisector WRITEs.

[PATCH 01/02] sata_mv: tidy up qc->tf usage in qc_prep() functions
[PATCH 02/02] sata_mv: workaround for multi_count errata sata24

Thanks
