Return-Path: <linux-kernel-owner+w=401wt.eu-S1764657AbXHFMV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764657AbXHFMV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763440AbXHFMVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:21:48 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:6339 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXHFMVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:21:47 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 08:21:46 EDT
X-lkernAT-MailScanner-Watermark: 1187007268.2013@f/vZNoeSQE6GL7xXnCF2Qg
Message-ID: <46B710A2.6020600@linux-kernel.at>
Date: Mon, 06 Aug 2007 14:14:26 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Alpha Kernel -Werror compilation problem...
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It seems somewhere in 2.6.23 -Werror has been added to
arch/alpha/kernel/Makefile.

That's bad, because of the following:

  CC      arch/alpha/kernel/sys_titan.o
cc1: warnings being treated as errors
arch/alpha/kernel/sys_titan.c: In function ‘titan_late_init’:
arch/alpha/kernel/sys_titan.c:281: warning: ignoring return value of
‘request_irq’, declared with attribute warn_unused_result
arch/alpha/kernel/sys_titan.c:283: warning: ignoring return value of
‘request_irq’, declared with attribute warn_unused_result
arch/alpha/kernel/sys_titan.c:285: warning: ignoring return value of
‘request_irq’, declared with attribute warn_unused_result
arch/alpha/kernel/sys_titan.c:287: warning: ignoring return value of
‘request_irq’, declared with attribute warn_unused_result
arch/alpha/kernel/sys_titan.c:289: warning: ignoring return value of
‘request_irq’, declared with attribute warn_unused_result
arch/alpha/kernel/sys_titan.c: In function ‘privateer_init_pci’:
arch/alpha/kernel/sys_titan.c:348: warning: ignoring return value of
‘request_irq’, declared with attribute warn_unused_result
arch/alpha/kernel/sys_titan.c:350: warning: ignoring return value of
‘request_irq’, declared with attribute warn_unused_result
make[1]: *** [arch/alpha/kernel/sys_titan.o] Error 1
make: *** [arch/alpha/kernel] Error 2


I don't know if something else would also fail. Well yes, we could fix
the warning also - anyone has time for it? :-)

Best,
 Oliver
