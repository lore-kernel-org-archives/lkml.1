Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZESVh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZESVh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZESVhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:37:51 -0400
Received: from sachiko.kuiki.net ([80.68.89.100]:48066 "EHLO sachiko.kuiki.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZESVhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:37:50 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2009 17:37:50 EDT
Date: Tue, 19 May 2009 14:30:08 -0700
From: Jonathan Steinert <hachi@kuiki.net>
To: linux-kernel@vger.kernel.org
Subject: problem with sata_sil24: PCI fault or device removal?
Message-ID: <20090519213008.GA21409@miyako.harrison.succub.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a box here running 2.6.26 x86_64 normally (also tested with 2.6.29, and going to test with later versions too) that has major issues with SATA. I'm not sure which things are causes and which things are side effects, so I'm just going to list symptoms.

I'm happy to use this machine for debugging, but I'm not subscribed to lkml. If you could please CC me on responses that would help a lot.

- The first error I usually see is:

sata_sil24: PCI fault or device removal?

- In some cases I've had the box hard-lock (no magic SysRq response or anything) with no errors.

- Booting a live OS with 2.6.25 @ 32bit seems to be just fine, but this could be a side effect of 32 vs 64bit. Not sure yet.

- SMART commands might make the situation worse. I was using smartmontools to run long self-tests on the drives every sunday, and tends to crash on sunday around the time of the long test starting. I was also using hddtemp and it got a little less frequent when I removed that.

- Lots of IO does make it worse. dd if=/dev/sdwhatever of=/dev/null can get it to start spewing errors within a minute usually.

- Logs and command outputs are at: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/

    lspci: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/lspci.txt
    lspci -vvv: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/lspci_long.txt
    dmesg: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/dmesg.txt
    console output during a crash: http://hachi.kuiki.net/bug_reports/20090519-linux-sata/crash1.txt

If anyone has time to help, it would be much appreicated. I'm able and willing to collect any other information you might want.

Thanks

--hachi

------------------------------------------------------------------------
"She smiled again, shrugged her shoulders, and became a perfect mirror."
------------------------------------------------------------------------
