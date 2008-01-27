Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYA0OCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYA0OCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 09:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYA0OCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 09:02:46 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57582 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYA0OCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 09:02:45 -0500
From: Sripathi Kodi <sripathik@in.ibm.com>
To: paulus@samba.org
Subject: [ppc] Disparity between sys_clock_getres and vdso implementation
Date: Sun, 27 Jan 2008 19:32:59 +0530
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       john stultz <johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801271932.59823.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On PPC, I see a disparity between clock_getres implementations in the
vdso and syscall. I am using a IBM Openpower hardware and 2.6.24 kernel
with CONFIG_HIGH_RES_TIMERS=y. 

clock_getres call for CLOCK_REALTIME returns 1 millisecond. However,
when I edit arch/powerpc/kernel/vdso*/gettimeofday.S to force it to use 
sys_clock_getres, I get 1 nanosecond resolution. The code in vdso seems
to be returning some pre-defined (incorrect) variables.

Could you please let me know the reason for this? Is it something that
should be fixed in vdso?

Thanks,
Sripathi.
