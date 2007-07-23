Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXGWMey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXGWMey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbXGWMer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:34:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46493 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbXGWMeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:34:46 -0400
Date: Mon, 23 Jul 2007 13:34:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
Message-ID: <20070723123443.GB3674@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Avi Kivity <avi@qumranet.com>, Shaohua Li <shaohua.li@intel.com>,
	kvm-devel <kvm-devel@lists.sourceforge.net>,
	lkml <linux-kernel@vger.kernel.org>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com> <46A4829C.9080104@qumranet.com> <20070723122510.GA3674@infradead.org> <46A49F30.5010206@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A49F30.5010206@qumranet.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 03:29:36PM +0300, Avi Kivity wrote:
> >Actually it requires lots of deep down VM internals symbols that'll never
> >get exported.
> >
> >  
> 
> What's "it" here?  kvm-specific address space or generic vmas.

The patches in this thread.

> Generic vmas will be more intrusive AFAICT.

People use intrusive differently.  Doing big changes to core code is not
a problem if we actually get a proper interface.  Just exporting core
function without other changes and then writing code in modules that
pokes into internals is much much worse.

