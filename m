Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZKSUFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZKSUFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZKSUFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:05:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38771
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330AbZKSUFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:05:33 -0500
Date: Thu, 19 Nov 2009 12:05:50 -0800 (PST)
Message-Id: <20091119.120550.183823935.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       zdavatz@gmail.com, linux-ide@vger.kernel.org
Subject: Re: [Bug #14622] Second IDE device not found
From: David Miller <davem@davemloft.net>
In-Reply-To: <xXQGFmujPl.A.n7F.4SdALB@chimera>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	<xXQGFmujPl.A.n7F.4SdALB@chimera>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 16 Nov 2009 23:37:47 +0100 (CET)

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14622
> Subject		: Second IDE device not found
> Submitter	: Zeno Davatz <zdavatz@gmail.com>
> Date		: 2009-11-11 17:31 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=125796105822353&w=4

We're going to need more information to diagnose this.

And linux-ide should have been at least CC:'d from the very
beginning.

>From what I can discern the problem is introduced somewhere between
2.6.27 and 2.6.31, you have a Serverworks CSB5 and primarily the issue
is that attaching or detaching your CD-ROM driver influences whether
both of your disks are properly detected.  Correct?

You seem to have played around with using the IDE layer vs. the
ATA layer.  Can you see any difference in behavior if you try
using just the IDE layer vs. just the ATA layer with the 2.6.31
kernel?

Thanks.
