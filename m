Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXEVDXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXEVDXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 23:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXEVDXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 23:23:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48086 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbXEVDXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 23:23:07 -0400
Message-ID: <46526216.2040000@garzik.org>
Date: Mon, 21 May 2007 23:23:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "George T. Joseph (development)" <gtj.devel@peakin.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ahci: add Marvell support (WIP)
References: <20070519054704.GA352@havoc.gtf.org> <22E26940476D1E48AA6F292B5316C9C33823@bes1.peakin.com>
In-Reply-To: <22E26940476D1E48AA6F292B5316C9C33823@bes1.peakin.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

George T. Joseph (development) wrote:
> Hi Jeff,
> 
> Two issues with the patch...
> 
> msi has to be disabled for the Marvell or the driver load will throw a
> "nobody cared" message and eventually hang before discovering all the
> drives.
> 
> Light I/O works fine but heavy I/O generates 
> "exception Emask 0x0 Sact 0xb Serr 0x0 action 0x2 frozen"
> Then softreset and identify failures.
> Adding AHCI_FLAG_NO_NCQ to the flags fixes this.
> 
> I've been running with both these changes over your original patch for a
> few months now with no problems.  This is on a very heavily used 4 drive
> mdraid10 array.  


I poked Marvell about this, we'll see what they say.

If I don't hear anything useful, I'll push the no-MSI, no-NCQ version 
upstream.

	Jeff


