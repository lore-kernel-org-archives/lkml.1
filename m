Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZL3Ii2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZL3Ii2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 03:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZL3Ii2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 03:38:28 -0500
Received: from chello212186124096.11.vie.surfer.at ([212.186.124.96]:59259
	"EHLO wiesinger.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZL3Ii1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 03:38:27 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Dec 2009 03:38:27 EST
Date: Wed, 30 Dec 2009 09:31:35 +0100 (CET)
From: Gerhard Wiesinger <lists@wiesinger.com>
To: linux-kernel@vger.kernel.org
Subject: ESX Server - GPL violation - found proof !?!
Message-ID: <alpine.LFD.2.00.0912300928070.20863@bbs.intern>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-MailScanner-Information-wiesinger-com: Please contact the ISP for more information
X-wiesinger-com-MailScanner-ID: nBU8VZrp021385
X-MailScanner-wiesinger-com: Found to be clean
X-MailScanner-SpamCheck-wiesinger-com: not spam, SpamAssassin (not cached,
	score=-3.668, required 4.5, ALL_TRUSTED -1.80, AWL -0.66,
	BAYES_00 -2.60, PLING_QUERY 1.39)
X-MailScanner-From: lists@wiesinger.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After looking for Buslogic VMWare docs I found the following:
There were often rumors that ESX server is based on Linux GPL code. I 
think I've found a prove for it from an official VMWare/EMC document (just 
save the PDF document for reference):
http://www.vmware.com/pdf/esx_15_manual.pdf
p.269:
ESX Server's Mylex (Buslogic) driver is based on the Linux BusLogic 
version 2.1.15 driver.

p.270:
The ESX Server uses two different drivers to support the device family, 
one based on the Linux ncr53c8xx version 3.4.3b driver and the other on 
the sym53c8xx version 1.7.3 driver.

More clearly stated that ESX SERVER is based on Linux driver GPL code and 
therefore ESX Server is derived work of Linux GPL v2 code and therefore 
the WHOLE ESX SERVER has to be put under GPL v2 (even when run as userland 
program of a Linux kernel, because the ESX source/driver depends on the 
Linux kernel and Linux GPL code is linked).

This is at least valid for VMWare ESX server 1.5.

Any comments? Any plans?

Ciao,
Gerhard Wiesinger

--
http://www.wiesinger.com

Some references:
http://blog.scottlowe.org/2007/08/19/the-linux-kernel-binary-modules-and-esx-server/
http://www.theregister.co.uk/2007/08/16/vmware_derived_from_linux/
http://linux.slashdot.org/article.pl?sid=07/08/14/1618241
http://communities.vmware.com/thread/98813?start=15&amp;tstart=0
http://downloads.vmware.com/d/info/datacenter_downloads/vmware_infrastructure_3/3_5#open_source
http://downloads.vmware.com/d/info/datacenter_downloads/vmware_vsphere_4/4#open_source
