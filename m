Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYBEJIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYBEJIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 04:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbYBEJHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 04:07:51 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:49543 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755862AbYBEJHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 04:07:49 -0500
Date: Tue, 5 Feb 2008 14:37:42 +0530
From: Chirag Jog <chirag@linux.vnet.ibm.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Sripathi Kodi <sripathik@in.ibm.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] [POWERPC] Use a sensible default for clock_getres() in
	the vdso.
Message-ID: <20080205090742.GA11087@linux.vnet.ibm.com>
Reply-To: Chirag Jog <chirag@linux.vnet.ibm.com>
Mail-Followup-To: Tony Breeds <tony@bakeyournoodle.com>,
	Sripathi Kodi <sripathik@in.ibm.com>, paulus@samba.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	john stultz <johnstul@us.ibm.com>
References: <200801271932.59823.sripathik@in.ibm.com> <20080205051648.GX6887@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080205051648.GX6887@bakeyournoodle.com>
Organization: IBM LTC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Breeds <tony@bakeyournoodle.com> [2008-02-05 16:16:48]:

> On Sun, Jan 27, 2008 at 07:32:59PM +0530, Sripathi Kodi wrote:
> > Hi Paul,
> > 
> > On PPC, I see a disparity between clock_getres implementations in the
> > vdso and syscall. I am using a IBM Openpower hardware and 2.6.24 kernel
> > with CONFIG_HIGH_RES_TIMERS=y. 
> > 
> > clock_getres call for CLOCK_REALTIME returns 1 millisecond. However,
> > when I edit arch/powerpc/kernel/vdso*/gettimeofday.S to force it to use 
> > sys_clock_getres, I get 1 nanosecond resolution. The code in vdso seems
> > to be returning some pre-defined (incorrect) variables.
> > 
> > Could you please let me know the reason for this? Is it something that
> > should be fixed in vdso?
> 
> Can you try the attached patch and see it if works for you?
I tried this patch.
It seems to solve the reported problem and give a 1ns resolution.
Thanks.
 

-- 
Cheers,
Chirag Jog

