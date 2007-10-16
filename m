Return-Path: <linux-kernel-owner+w=401wt.eu-S935617AbXJPULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935617AbXJPULS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760613AbXJPULD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:11:03 -0400
Received: from mga10.intel.com ([192.55.52.92]:9932 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759551AbXJPULB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:11:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="347913679"
Date: Tue, 16 Oct 2007 13:10:22 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071016201022.GC23157@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com> <20071015191732.GA1841@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015191732.GA1841@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 11:17:32PM +0400, Alexey Dobriyan wrote:
> On Mon, Oct 15, 2007 at 10:04:11AM -0700, Mark Gross wrote:
> > On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> > > http://kernelnewbies.org/KernelProjects
> > 
> > Is there already a make config option that will do a good job at setting
> > a default .config file based on what is already running on a system?  
> > 
> > I get tiered of trimming down my .config for my laptop build so it takes
> > less than 30min to build a kernel.
> 
> Ehh? You do it once, then leave it aside or in /proc/config.gz, on new
> kernel copy it back, "make oldconfig", answer several questions and here
> we go.

yeah I know that.  Its a lot more than a few questions, and as we are
talking about a linear search for a fully tweaked .config where each
pass takes 30 min to know if things work this isn't how I want to spend
my time.

--mgross

> 
> > Bonus credit to additional "expert" options (like those powertop puts
> > out) for target uses, laptop, HPC, home file share, embedded targets....
> > 
> > Oh, and lets make the expert configs easily extensible.
