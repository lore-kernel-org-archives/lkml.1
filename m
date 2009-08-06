Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZHFOtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZHFOtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZHFOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:49:45 -0400
Received: from bar.sig21.net ([80.81.252.164]:44756 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbZHFOtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:49:45 -0400
Date: Thu, 6 Aug 2009 16:49:38 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13644] hibernation/swsusp lockup due to acpi-cpufreq
Message-ID: <20090806144938.GA6817@sig21.net>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
 <7ixSg7D88bK.A.i2F.UqgdKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ixSg7D88bK.A.i2F.UqgdKB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.1 (---)
X-Spam-21-Report: No, score=-3.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=1.300,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 09:09:32PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13644
> Subject		: hibernation/swsusp lockup due to acpi-cpufreq
> Submitter	: Johannes Stezenbach <js@sig21.net>
> Date		: 2009-06-16 01:27 (48 days old)
> References	: http://lkml.org/lkml/2009/6/15/630
> 		  http://lkml.org/lkml/2009/6/29/504
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>

This issue is fixed in linux-2.6.31-rc5-246-g90bc1a6,
I'm guessing due to

 commit 4bc5d34135039566b8d6efa2de7515b2be505da8
 Author: Dave Jones <davej@redhat.com>
 Date:   Tue Aug 4 14:03:25 2009 -0400

    [CPUFREQ] Make cpufreq suspend code conditional on powerpc.


Thanks,
Johannes
