Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbYKJQLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbYKJQLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYKJQLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:11:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42602 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYKJQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:11:09 -0500
Date: Mon, 10 Nov 2008 16:11:05 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: ACPI crash on lid close - SMP race?
Message-ID: <20081110161105.GA2041@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the _DOS flag on my HP 2510p is set to 0 (ie, signal OS when screen 
notification is requested, don't change automatically) then it'll crash 
on random lid open/closes. The trace generally makes little sense and 
depends on the kernel version and phase of the moon. I'd ignored this as 
firmware brokenness up until lately, but since having _DOS set to 0 is 
the only way to get a notification when the display switch key is 
pressed on this machine I'd be interested in fixing it properly. 

Unfortunately, I've got no real idea what on earth is going on. The only 
clue I've found so far is that booting with maxcpus=1 leaves it working 
perfectly. What parts of the ACPI stack could be triggering this?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
