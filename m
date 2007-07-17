Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbXGQIRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbXGQIRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXGQIRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:17:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:44384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbXGQIRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:17:34 -0400
Date: Tue, 17 Jul 2007 10:17:24 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070717081724.GA16853@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com> <20070713200533oomichi@mail.jp.nec.com> <20070713131550.GB10985@suse.de> <20070716041918.GA11390@in.ibm.com> <20070716115707.GA29923@suse.de> <20070717035055.GA4869@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717035055.GA4869@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-17 05:50]:
> 
> Thinking more about it. These config variables are accessible in user
> space in first kernel through sysconf() interface. In that case kexec
> can pack required config variables into an ELF note and kernel does not
> have to intervene.

That's a good point. So we'd only need to aggree on a format for all
this information. I think the makedumpfile format is quite good --
instead of inventing another new format.


Thanks,
   Bernhard
