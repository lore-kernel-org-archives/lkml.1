Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbXGPMgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbXGPMgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbXGPMgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:36:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37318 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbXGPMge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:36:34 -0400
Date: Mon, 16 Jul 2007 18:06:33 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       Bernhard Walle <bwalle@suse.de>, Dan Aloni <da-x@monatomic.org>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070716123633.GA10920@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com> <20070713200533oomichi@mail.jp.nec.com> <20070713131550.GB10985@suse.de> <20070716041918.GA11390@in.ibm.com> <20070716115707.GA29923@suse.de> <20070716122518.GA10506@in.ibm.com> <20070716122854.GC32519@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716122854.GC32519@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 02:28:54PM +0200, Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-07-16 14:25]:
> > 
> > Ok. Now there seems to be two ways for accessing such info.
> > - Through global variables
> > - Export through ELF notes.
> > 
> > Personally, I like the approach taken by Dan Aloni of exporting required
> > info through ELF notes. That seems to be more standard in the sense we 
> > are not dependent on somebody removing above variable tomorrow.
> > 
> > Dan, are you planning to put the modified patch for discussions on LKML?
> 
> You mean the proposal with the makedumpfile-compatible ELF note?
> Although I like that idea, I think Ken'ichi Ohmichi was against it.
> 

Yes, makedumpfile compatible ELF note one. Ken'ichi did not like the idea
too much, but I am not sure we discussed his objections in detail. I had
also responded with a mail with some of the advantages of ELF note based
approach. No response on that.

Thanks
Vivek
