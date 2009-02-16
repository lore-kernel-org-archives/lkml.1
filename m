Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZBPH3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZBPH3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbZBPH3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:29:22 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:25377 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZBPH3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:29:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=ZS82Nwe4gT3aqN60f3EWVdyfv7+MrIfUSItwoePhzitLDGz4Nc1qvZLT/YCvA53PDF
         Tml6Cdkj1MO/ISvX74+zNG6FwexqKgxpO1f+uFq4FJGYX5L/83dnGkotugO4igjw9wRu
         syxu2l3SrexeL1zP5C5tzF2XsObBjn23WoL10=
Date: Mon, 16 Feb 2009 07:29:10 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
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
Subject: Re: 2.6.29-rc5: Reported regressions from 2.6.28
Message-ID: <20090216072910.GA4763@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-02-2009 21:35, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.28, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.
...
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12615
> Subject		: boot hangs while bringing up gianfar ethernet
> Submitter	: Ira Snyder <iws@ovro.caltech.edu>
> Date		: 2009-01-29 19:41 (17 days old)
> References	: http://marc.info/?l=linux-kernel&m=123325817201665&w=4

Fixed by:
commit	8707bdd48ab705a459ac1b12014075a139d1d4f9
gianfar: Fix boot hangs while bringing up gianfar ethernet
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8707bdd48ab705a459ac1b12014075a139d1d4f9

Cheers,
Jarek P.
