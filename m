Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbXDFRFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbXDFRFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXDFRFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:05:52 -0400
Received: from bart.ott.istop.com ([66.11.172.99]:47504 "EHLO jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbXDFRFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:05:51 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 13:05:51 EDT
Date: Fri, 6 Apr 2007 11:46:28 -0400
From: Bart Trojanowski <bart@jukie.net>
To: fastboot@lists.osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: restoring x86 BIOS state before reboot
Message-ID: <20070406154628.GG12005@jukie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am looking at a two stage boot where linux is loaded to do some system
initialization before booting to Windows, which needs BIOS.

I am interested in bypassing the BIOS on the second boot.

I wanted to know if anyone has attempted to restore the BIOS memory such 
that this could be attempted.  If not, I would love to get some pointers
:)

My plan right now is to backup the 128k of memory under 0x10000 to some
staging memory under 0x90000, temporarily while in real mode, and then
move it up somewhere higher once the kernel is running.

Then on reboot I hope to undo the above and jump to 0x00007c00.

Does this approach have any merit?

Cheers,

-Bart
