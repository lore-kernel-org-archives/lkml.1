Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZJGPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZJGPjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759468AbZJGPjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:39:18 -0400
Received: from xenotime.net ([72.52.64.118]:33789 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753403AbZJGPjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:39:17 -0400
Date: Wed, 7 Oct 2009 08:38:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Venkatraman S <svenkatr@ti.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH v2] SDMA: Fixing bug in omap_dma_set_global_params()
Message-Id: <20091007083836.89b48fbd.rdunlap@xenotime.net>
In-Reply-To: <618f0c910910070218q496eeb9dgf200ffd5d6583aef@mail.gmail.com>
References: <1254732163-3509-1-git-send-email-anuj.aggarwal@ti.com>
	<20091005094102.1385b418.rdunlap@xenotime.net>
	<618f0c910910070218q496eeb9dgf200ffd5d6583aef@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 14:48:26 +0530 Venkatraman S wrote:

> On Mon, Oct 5, 2009 at 10:11 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Mon,  5 Oct 2009 14:12:43 +0530 Anuj Aggarwal wrote:
> >
> >> Argument tparams was not being used to program
> >> global register GCR.HI_THREAD_RESERVED. This patch fixes the same.
> >>
> >> Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
> >> ---
> >>  arch/arm/plat-omap/dma.c |   15 +++++++++------
> >>  1 files changed, 9 insertions(+), 6 deletions(-)
> >
> >
> > Hi,
> > Someone please convert all of this source file to correct kernel-doc notation.
> >
> > Thanks.
> >
> 
> I now have this on my TODO list. As a bug fix, shouldn't this be
> pulled in and the doc updates for all the functions can be done as a
> separate patch ?

Yes.  Thanks.

> Anuj,
>  Can you please correct the comments for this function to proper
> format along with your changes ?
> 
> Thanks,
> Venkat.


---
~Randy
