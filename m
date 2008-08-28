Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYH1TF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYH1TF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYH1TFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:05:14 -0400
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:16941
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbYH1TFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:05:13 -0400
X-Trace: 75589473/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4EAIGTtkjDlSwG/2dsb2JhbACBZbkKgWo
X-IronPort-AV: E=Sophos;i="4.32,288,1217804400"; 
   d="scan'208";a="75589473"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Neil Brown <neilb@suse.de>
Subject: md (regression): reboot/shutdown hangs
Date: Thu, 28 Aug 2008 20:05:09 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc4-bisect-damocles; KDE/4.1.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808282005.09416.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

Commit 2b25000bf5157c28d8591f03f0575248a8cbd900 ("Restore force switch of md 
array to readonly at reboot time.") causes a reboot/shutdown to hang 
indefinitely on my box. Reverting this single commit makes the problem go 
away. It was first released with 2.6.27-rc3, I believe, and so this is a 
regression vs 2.6.26 (Rafael CCed).

I think the problem might be because my rootfs is on a RAID5 and my distro 
fails to stop it completely before halt/reboot.

Please let me know if there's any more information you need from me.

-- 
Cheers,
Alistair.
