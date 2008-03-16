Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYCPFjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYCPFjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 01:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYCPFiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 01:38:54 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:42206 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbYCPFix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 01:38:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsBAKdP3EdBXyn6/2dsb2JhbAAIpxE
Message-ID: <47DCB26B.20907@sympatico.ca>
Date: Sun, 16 Mar 2008 01:38:51 -0400
From: Allan Menezes <amenezes007@sympatico.ca>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.2) Gecko/20040804 Netscape/7.2 (ax)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: HPL benchmarking linux kernel for shared memory performance.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I eliminated in which kernel verion this begins to happen. I am 
benchmarking a single node with hpl and openmpi beta 1.3 and gotoblas v1.24
for personal noncommercial reasons.
I tried a single node with the command $ mpirun -np 1 ./xhpl
and with kernel ver 2.6.23.14 i get over 38Gflops
but with kernel ver 2.6.23.15 compiling with the same .config i get 7.xx 
Gflops which is 1/5th that of the other kernel.
Keep in mind that only the kernels have changed from kernel.org not any 
hardware or anything else as all else is same! but the  performace drops 
to 1/5th
There is no network involved in this single node quad core intel test 
but just shared memory.
So the shared memory or smp performance of the newer kernels is far far 
worse than upto 2.6.23.14!
Even with 2.6.25.rc5 the performance is degraded!
Can you please help me find why this is occurring? Please advise!
mY set up Quad core Q6600 intel overclocked stably to 2.88 GHZ , 6 gig 
ddr2 800 mhz dual channel ram,
Allan Menezes
