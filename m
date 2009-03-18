Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZCROEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZCROEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbZCROEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:04:12 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:60882 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbZCROEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:04:10 -0400
X-Greylist: delayed 1963 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Mar 2009 10:04:09 EDT
Message-ID: <49C0F780.2020904@systec-electronic.com>
Date: Wed, 18 Mar 2009 14:30:40 +0100
From: =?ISO-8859-15?Q?Daniel_Kr=FCger?= 
	<daniel.krueger@systec-electronic.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kernel_thread() usage found in staging
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

sorry for stepping in. I found the original posting via Google while 
trying to compile the openPOWERLINK protocol stack with a recent Linux 
kernel. I am the official maintainer of openPOWERLINK.

 > ./epl/ShbIpc-LinuxKernel.c:
 > 	    kernel_thread(ShbIpcThreadSignalNewData, pShbInstance_p,
 > 	    kernel_thread(ShbIpcThreadSignalJobReady, pShbInstance_p,
 >
 > ./epl/EplSdoUdpu.c:
 > 	    kernel_thread(EplSdoUdpThread, &SdoUdpInstance_g, CLONE_KERNEL);

As I understand, there are some issues (race conditions) with the 
kthread-API and signals. I need signals, because the kernel-threads may 
block in some I/O functions.

What is the right way to use the kthread-API with signals? Or are there 
any solutions to avoid signals?
Is there any sample code that shows how to do it?

Thanks in advance for any help.

Regards,
   Daniel Krüger

--
SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Telefon  : +49 (0) 3661 6279 0
Fax      : +49 (0) 3661 6279 99
Email    : daniel.krueger@systec-electronic.com
Internet : http://www.systec-electronic.com

Managing Director   : Dipl.-Phys. Siegmar Schmidt
Commercial registry : Amtsgericht Jena, HRB 205563
