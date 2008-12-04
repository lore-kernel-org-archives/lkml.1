Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYLDARh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYLDARh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLDARV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:17:21 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57282 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbYLDART (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:17:19 -0500
Subject: Re: 2.6.28-rc7-git2: Reported regressions from 2.6.27
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 18:17:21 -0600
Message-Id: <1228349841.5551.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 22:49 +0100, Rafael J. Wysocki wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12120
> Subject         : [Block layer or SCSI] requests aborted too early
> during check_partition()
> Submitter       : Stefan Richter <stefan-r-bz@s5r6.in-berlin.de>
> Date            : 2008-11-29 05:19 (5 days old)

Fixed by this patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9728c0814ecb505546696a659858fdb761375544

James


