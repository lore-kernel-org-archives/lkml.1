Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbXGZAPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbXGZAPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXGZAPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:15:24 -0400
Received: from mail.reagi.com ([195.60.188.80]:43360 "EHLO mail.reagi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbXGZAPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:15:23 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2007 20:15:22 EDT
Message-ID: <46A7E606.4030001@oxeva.fr>
Date: Thu, 26 Jul 2007 02:08:38 +0200
From: Gabriel Barazer <gabriel@oxeva.fr>
Organization: OXEVA
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.22 x86_64 : kernel initial decompression hangs on vmware
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After upgrading kernel to 2.6.22 on a Vmware workstation guest version 
5.5 and 6 , the kernel decompression stage ("Decompressing Linux...") is 
hanging for a very long time (~5 minutes) before finally  succeeding 
(displaying "done.\nBooting the kernel.\n"). During this time, the VM 
process is eating all the CPU time during the decompression, like an 
infinite loop.
Between these 2 strings is the gunzip() function at 
boot/compressed/misc.c which does the real job, and the problem seemed 
to appear since commit 1ab60e0f72f71ec54831e525a3e1154f1c092408. 
(2.6.22-rc1 hangs, 2.6.21.6 works). The problem occurs with or without 
CONFIG_RELOCATABLE enabled.

What are the possible solutions to confirm where the problem is coming 
from ?

Thanks,

Gabriel
