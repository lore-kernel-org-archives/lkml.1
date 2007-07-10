Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbXGJSxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbXGJSxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXGJSxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:53:05 -0400
Received: from userbg049.dsl.pipex.com ([62.190.246.49]:4136 "EHLO
	homer.intra.qzxyz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751475AbXGJSxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:53:04 -0400
X-Greylist: delayed 1834 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 14:53:03 EDT
Message-ID: <4693CE63.1090102@talk21.com>
Date: Tue, 10 Jul 2007 19:22:27 +0100
From: Scott Ashcroft <scott.ashcroft@talk21.com>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Always zero test in arch/i386/pci/mmconfig-shared.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think it makes any change to subsequent flow but the code in 
pci_mmcfg_check_hostbridge is:

pci_mmcfg_config_num = 0;

...

if (name) {
	printk(KERN_INFO "PCI: Found %s %s MMCONFIG support.\n",
	       name, pci_mmcfg_config_num ? "with" : "without");
}

So it will always prints "without".

I'd make a patch but I'm not sure what this fix is. Just drop the test, 
the printk or make it say "which might possibly have"?

Cheers,
Scott
