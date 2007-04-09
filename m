Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbXDIIYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbXDIIYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 04:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXDIIYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 04:24:49 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:39421 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXDIIYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 04:24:47 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] pata_icside driver
X-Message-Flag: Warning: May contain useful information
References: <20070330110022.GA21653@flint.arm.linux.org.uk>
	<20070330110800.GB21653@flint.arm.linux.org.uk>
	<20070408101826.GA5431@flint.arm.linux.org.uk>
	<20070408210917.6e306851@the-village.bc.nu>
	<20070409081824.GA28366@flint.arm.linux.org.uk>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 09 Apr 2007 01:24:45 -0700
In-Reply-To: <20070409081824.GA28366@flint.arm.linux.org.uk> (Russell King's message of "Mon, 9 Apr 2007 09:18:24 +0100")
Message-ID: <adahcrq550y.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Apr 2007 08:24:45.0496 (UTC) FILETIME=[87BB7380:01C77A80]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Lets say that we want to do MW DMA mode 2.  This has the minimum timing
 > of 70ns active, 25ns recovery, 120ns cycle time.
 > 
 > When you quantise those figures using a clock period of 62.5ns (16MHz)
 > you end up with: 2 clocks active (2*62.5 > 70), 1 clock recovery
 > (1*62.5 > 25) and 2 clocks cycle (2*62.5 > 120).
 > 
 > Last time I checked, active + recovery must always be equal to the cycle
 > time, and unless my math is failing me, 2 + 1 does not equal 2.

Do you mean active + recovery must be less than or equal to the cycle
time?  Because 70ns + 25ns does not equal 120ns either...

 - R.
