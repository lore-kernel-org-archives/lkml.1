Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYADP4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYADP4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 10:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYADPz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 10:55:56 -0500
Received: from ioctl.codeblau.de ([80.190.240.67]:45415 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752609AbYADPz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:55:56 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2008 10:55:55 EST
Date: Fri, 4 Jan 2008 16:49:14 +0100
From: felix-linuxkernel@fefe.de
To: linux-kernel@vger.kernel.org
Subject: memory remapping, 4gb memory on 945gt
Message-ID: <20080104154914.GA589@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently put 4 GB of memory in my Acer Travelmate 8210 series
notebook.  The BIOS only detects 3 GB.

I googled around a little.  It appears to be a chipset limitation of the
945gt, which uses the fourth gig for devices.

Now I can understand this explanation for 32-bit mode, but I'm running
in 64-bit mode.  There should be a way to use the fourth gig under
Linux.  Is there?

Has anyone else solved this problem?  What happens if you just use the
mem= option to tell the kernel you have 4 GB?  I'd just try it but I
don't want to corrupt my buffer cache and get crap writte over my data
on disk.

Any advice?

Felix
