Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbXGPETY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbXGPETY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 00:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbXGPETS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 00:19:18 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58709 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbXGPETR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 00:19:17 -0400
Date: Mon, 16 Jul 2007 09:49:19 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070716041918.GA11390@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com> <20070713200533oomichi@mail.jp.nec.com> <20070713131550.GB10985@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713131550.GB10985@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 03:15:50PM +0200, Bernhard Walle wrote:
> * Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp> [2007-07-13 13:05]:
> > 
> > BTW, I'd like to remove PAGESIZE from a mkdfinfo file.
> > While 2nd-kernel is running, new makedumpfile comes to consider
> > 2nd-kernel PAGESIZE as 1st-kernel PAGESIZE without getting PAGESIZE
> > from a mkdfinfo file.
> 
> I don't think that's a good idea. IMO the kernel should be modified to
> export the page size in a variable for that purpose. That would solve
> all problems and dependencies, doesn't it?
> 

Agreed. We need to export PAGESIZE from kernel instead of assuming that
second kernel as got same page size as first kernel.

Thanks
Vivek
