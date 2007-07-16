Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbXGPM3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbXGPM3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXGPM2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:28:55 -0400
Received: from ns2.suse.de ([195.135.220.15]:41181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXGPM2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:28:55 -0400
Date: Mon, 16 Jul 2007 14:28:54 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070716122854.GC32519@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com> <20070713200533oomichi@mail.jp.nec.com> <20070713131550.GB10985@suse.de> <20070716041918.GA11390@in.ibm.com> <20070716115707.GA29923@suse.de> <20070716122518.GA10506@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716122518.GA10506@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-16 14:25]:
> 
> Ok. Now there seems to be two ways for accessing such info.
> - Through global variables
> - Export through ELF notes.
> 
> Personally, I like the approach taken by Dan Aloni of exporting required
> info through ELF notes. That seems to be more standard in the sense we 
> are not dependent on somebody removing above variable tomorrow.
> 
> Dan, are you planning to put the modified patch for discussions on LKML?

You mean the proposal with the makedumpfile-compatible ELF note?
Although I like that idea, I think Ken'ichi Ohmichi was against it.


Thanks,
   Bernhard
