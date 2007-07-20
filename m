Return-Path: <linux-kernel-owner+w=401wt.eu-S1762716AbXGTHgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762716AbXGTHgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764260AbXGTHfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:35:51 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:49791 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764145AbXGTHfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:35:50 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <200707200813.03553.a1426z@gawab.com>
References: <200707200813.03553.a1426z@gawab.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4FEA8E81-3BA7-4F8C-AFD2-6B93487A9AD5@cam.ac.uk>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFH] Partion table recovery
Date: Fri, 20 Jul 2007 08:35:45 +0100
To: Al Boldi <a1426z@gawab.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Jul 2007, at 06:13, Al Boldi wrote:
> As always, a good friend of mine managed to scratch my partion  
> table by
> cat'ing /dev/full into /dev/sda.  I was able to push him out of the  
> way, but
> at least the first 100MB are gone.  I can probably live without the  
> first
> partion, but there are many partitions after that, which I hope should
> easily be recoverable.
>
> I tried parted, but it's not working out for me.  Does anybody know  
> of a
> simple partition recovery tool, that would just scan the disk for lost
> partions?

parted and its derivatives are pile of crap...  They cause corruption  
to totally healthy systems at the best of times.  Don't go near them.

Use TestDisk (http://www.cgsecurity.org/wiki/TestDisk) and be happy.   
(-:

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


