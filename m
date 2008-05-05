Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYEER03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYEER03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYEER0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:26:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:32678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYEER0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:26:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,438,1204531200"; 
   d="scan'208";a="380190221"
Date: Mon, 5 May 2008 10:26:19 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Message-ID: <20080505172619.GD28173@linux-os.sc.intel.com>
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481D7BF8.4080405@numericable.fr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 11:03:52AM +0200, Rufus & Azrael wrote:
> Ingo Molnar a écrit :
> >* Rufus & Azrael <rufus-azrael@numericable.fr> wrote:
> >>When upgrading to 2.6.25-git18 and above kernel this Xorg error occurs :
> >>
> >>xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000) (Invalid 
> >>argument)
> >>
> >>The latest working kernel was 25-git17 and perhaps is it related to 
> >>http://lkml.org/lkml/2008/4/28/52
> >>    
> >
> >does this X-does-not-start-up problem go away if you disable this 
> >option:
> >  
> >>CONFIG_X86_PAT=y
> >>    
> >
> >?
> >  
> Thanks for your help Ingo, all work fine when CONFIG_PAT=n :-)

hi, Can you please send us the "dmesg" output in the failing scenario
with PAT enabled, after the X crash?

thanks,
suresh
