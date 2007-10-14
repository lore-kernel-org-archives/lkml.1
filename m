Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbXJNRnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbXJNRnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXJNRnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:43:01 -0400
Received: from mail.phibo.org ([88.198.20.249]:41323 "EHLO mail.phibo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbXJNRnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:43:00 -0400
X-Greylist: delayed 2116 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 13:43:00 EDT
X-Spam-Summary: -2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.7 AWL                    AWL: From: address is in the auto white-list
Date: Sun, 14 Oct 2007 19:07:38 +0200
From: Philip <phibo@phibo.org>
To: linux-kernel@vger.kernel.org
Subject: System.map
Message-Id: <20071014190738.58349165.phibo@phibo.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello 

I want to write a script, which shows the name of the relevant kernel module for each listed pci device shown by 'lspci -m'. It's easy to find out the name of the corresponding module, if the driver has been compiled as a loadable kernel module: The file /lib/modules/$(uname -r)/modules.pcimap lists module names based on pci device's vendor -and device id (shown by 'lspci -n'). But how can I find out the name of the corresponding kernel module if the module has been compiled directly into the kernel ? I thought that I can find them in the kernel's machting System.map based on vendor -and device id as well. But I can't find those id's there. Where do I have to look for it ? I want to be informed by my script, if the driver (module) for a specific pci device is available as a loadable module, in-kernel module or not available at all.

Many thanks in advance for your answers and I hope, my question is not too annoying for you developer guys :-)


Cheers,
Phibo  
