Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXGWMZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXGWMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXGWMZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:25:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35097 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbXGWMZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:25:19 -0400
Date: Mon, 23 Jul 2007 13:25:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
Message-ID: <20070723122510.GA3674@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Avi Kivity <avi@qumranet.com>, Shaohua Li <shaohua.li@intel.com>,
	kvm-devel <kvm-devel@lists.sourceforge.net>,
	lkml <linux-kernel@vger.kernel.org>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com> <46A4829C.9080104@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A4829C.9080104@qumranet.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:27:40PM +0300, Avi Kivity wrote:
> Having an address_space (like your patch does) is remarkably simple, and 
> requires few hooks from the current vm.  However using existing vmas 
> mapped by the user has many advantages:

Actually it requires lots of deep down VM internals symbols that'll never
get exported.

