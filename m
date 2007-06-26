Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXFZFxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXFZFxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXFZFxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:53:16 -0400
Received: from verein.lst.de ([213.95.11.210]:39822 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbXFZFxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:53:15 -0400
Date: Tue, 26 Jun 2007 07:52:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-ia64@vger.kernel.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>,
       anil.s.keshavamurthy@intel.com, ananth@in.ibm.com
Subject: Re: [PATCH 2/3] Remove JPROBE_ENTRY()
Message-ID: <20070626055236.GA6841@lst.de>
References: <78935473b1f70c863ab0be7d6cf4bcb04922b20b.1182822366.git.michael@ellerman.id.au> <98c8ff25191ced991066092ffd4899526097da1e.1182822366.git.michael@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98c8ff25191ced991066092ffd4899526097da1e.1182822366.git.michael@ellerman.id.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 11:48:51AM +1000, Michael Ellerman wrote:
> AFAICT now that jprobe.entry is a void *, JPROBE_ENTRY doesn't do
> anything useful - so remove it ..
> 
> I've left a do-nothing version so that out-of-tree jprobes code will still
> compile without modifications.

Please kill the definition.  We don't want to keep unused crap around
just to let code compile.  And I have some plans for even deeper change
in this area, so they'll have to change anyway.

