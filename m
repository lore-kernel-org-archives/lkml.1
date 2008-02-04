Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYBDGsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYBDGsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 01:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYBDGsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 01:48:13 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:49963 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYBDGsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 01:48:12 -0500
X-Greylist: delayed 2269 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 01:48:12 EST
Date: Mon, 4 Feb 2008 17:08:30 +1100
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [ppc] Disparity between sys_clock_getres and vdso implementation
Message-ID: <20080204060830.GS6887@bakeyournoodle.com>
References: <200801271932.59823.sripathik@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801271932.59823.sripathik@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 07:32:59PM +0530, Sripathi Kodi wrote:
> Hi Paul,
> 
> On PPC, I see a disparity between clock_getres implementations in the
> vdso and syscall. I am using a IBM Openpower hardware and 2.6.24 kernel
> with CONFIG_HIGH_RES_TIMERS=y. 
> 
> clock_getres call for CLOCK_REALTIME returns 1 millisecond. However,
> when I edit arch/powerpc/kernel/vdso*/gettimeofday.S to force it to use 
> sys_clock_getres, I get 1 nanosecond resolution. The code in vdso seems
> to be returning some pre-defined (incorrect) variables.
> 
> Could you please let me know the reason for this? Is it something that
> should be fixed in vdso?

Almost certainly It's something I missed when I enabled highres timers
on powerpc.

I'll fix this tomorrow.

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

