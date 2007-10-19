Return-Path: <linux-kernel-owner+w=401wt.eu-S934997AbXJSDaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934997AbXJSDaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXJSDaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:30:00 -0400
Received: from slackadelic.com ([65.196.224.53]:51951 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbXJSD37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:29:59 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 23:29:59 EDT
From: Carlos Corbacho <cathectic@slackadelic.com>
To: linux-kernel@vger.kernel.org
Subject: nVidia HPET force enable - merge requirements? (resend)
User-Agent: KMail/1.9.7
Cc: Mikko Tiihonen <mikko.tiihonen@iki.fi>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 19 Oct 2007 04:23:31 +0100
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200710190423.31714.cathectic@slackadelic.com>
X-slackadelic.com-MailScanner-Information: Please contact the ISP for more information
X-slackadelic.com-MailScanner: Found to be clean
X-slackadelic.com-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.1, required 4, RDNS_DYNAMIC 0.10)
X-slackadelic.com-MailScanner-From: cathectic@slackadelic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend with CC's fixed)

Back in April, Mikko posted a patch to force enable the HPET on some nVidia 
chipsets:

v2:
http://lkml.org/lkml/2007/4/16/46

v3:
http://lkml.org/lkml/2007/4/17/354

What would need to be done to this patch to get it into x86 now (besides i386/ 
x86_64 -> x86 conversion), given that:

A) There is now a force_hpet boot parameter in the x86 tree (mm branch) 
(rather than relying on the solution in the earlier patches of a config 
option).

B) On the other hand, the force-quirk's are going into quirks.c, whilst 
Mikko's patch requires PCI scanning in early_quirks.c (could the PCI scanning 
be done in early_quirks.c and the actual HPET enabling handled in quirks.c 
later - or if not, could this early quirk play be made to obey the force_hpet 
boot option)?

-Carlos
-- 
E-Mail: cathectic@gmail.com
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
