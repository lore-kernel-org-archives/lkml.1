Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZHCJTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZHCJTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZHCJTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:19:36 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:49737 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZHCJTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:19:35 -0400
X-SpamScore: -24
X-BigFish: VPS-24(z34a4jz62a3L1432R98dN936eM4015Lzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNSN8E-01-480-02
X-M-MSG: 
Date: Mon, 3 Aug 2009 11:19:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [Bug #13809] oprofile: possible circular locking dependency
	detected
Message-ID: <20090803091924.GB25478@erda.amd.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.YTD.eHObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3zAHs5O6maO.A.YTD.eHObKB@chimera>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Aug 2009 09:19:25.0553 (UTC) FILETIME=[7EAEAE10:01CA141B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I also tested v2.6.31-rc4 with prove-locking enabled and could not
trigger the warning. My regression runs fine. Please provide more
information (workloads, oprofile setup, cpu info, kernel config) to be
able to reproduce this.

Thanks,

-Robert

On 26.07.09 22:28:24, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13809
> Subject		: oprofile: possible circular locking dependency detected
> Submitter	: Jerome Marchand <jmarchan@redhat.com>
> Date		: 2009-07-22 13:35 (5 days old)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

