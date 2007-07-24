Return-Path: <linux-kernel-owner+w=401wt.eu-S1761915AbXGXCGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915AbXGXCGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 22:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXGXCGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 22:06:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:43597 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbXGXCGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 22:06:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="271833808"
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070723123443.GB3674@infradead.org>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>
	 <46A4829C.9080104@qumranet.com> <20070723122510.GA3674@infradead.org>
	 <46A49F30.5010206@qumranet.com>  <20070723123443.GB3674@infradead.org>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 10:00:55 +0800
Message-Id: <1185242455.24201.30.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 20:34 +0800, Christoph Hellwig wrote:
> On Mon, Jul 23, 2007 at 03:29:36PM +0300, Avi Kivity wrote:
> > >Actually it requires lots of deep down VM internals symbols that'll
> never
> > >get exported.
> > >
> > > 
> >
> > What's "it" here?  kvm-specific address space or generic vmas.
> 
> The patches in this thread.
> 
> > Generic vmas will be more intrusive AFAICT.
> 
> People use intrusive differently.  Doing big changes to core code is
> not
> a problem if we actually get a proper interface.  Just exporting core
> function without other changes and then writing code in modules that
> pokes into internals is much much worse.
The patch follows the same way shm swap out pages. The only difference
is kvm is a module but shm not. why kvm can't use the symbols shm used?

Sure, it's possible to write guest memory to a file so not use the
symbols, if you really hate this, I'll consider the alternative method.

Thanks,
Shaohua
