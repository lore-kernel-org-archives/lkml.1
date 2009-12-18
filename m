Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZLRWYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZLRWYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZLRWYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:24:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:32304 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZLRWX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:23:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,420,1257148800"; 
   d="scan'208";a="757557998"
Subject: Re: kexec reboot broken with ioatdma?
From: Dan Williams <dan.j.williams@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Simon Horman <horms@verge.net.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>
In-Reply-To: <adafx773ox9.fsf@roland-alpha.cisco.com>
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
	 <20091216224912.GC16219@verge.net.au>
	 <aday6l27c7w.fsf@roland-alpha.cisco.com> <4B296930.9020704@intel.com>
	 <adatyvq7bbi.fsf@roland-alpha.cisco.com>
	 <1261174241.16958.6.camel@dwillia2-linux.ch.intel.com>
	 <adafx773ox9.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 15:23:20 -0700
Message-Id: <1261175000.16958.8.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 15:20 -0700, Roland Dreier wrote:
> > Subject: ioat2,3: put channel hardware in known state at init
>  > 
>  > Put the ioat2 and ioat3 state machines in the halted state with all
>  > errors cleared.
> 
> Yes, with this applied I was able to kexec reboot from a kernel with
> ioatdma loaded and have ioatdma work in the new kernel.  So:
> 
> Tested-by: Roland Dreier <rolandd@cisco.com>

What was that, all of 8 minutes to turn that test around! :-) Nice.

Thanks,
Dan


