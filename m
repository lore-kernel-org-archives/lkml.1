Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYJIVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYJIVfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYJIVfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:35:38 -0400
Received: from sous-sol.org ([216.99.217.87]:47612 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755618AbYJIVfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:35:36 -0400
Date: Thu, 9 Oct 2008 14:34:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Message-ID: <20081009213433.GG6912@sequoia.sous-sol.org>
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com> <20081009130518.GE1623@ucw.cz> <20081009175000.GC6912@sequoia.sous-sol.org> <D936D925018D154694D8A362EEB0892005B12E14@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D936D925018D154694D8A362EEB0892005B12E14@orsmsx416.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Cihula, Joseph (joseph.cihula@intel.com) wrote:
> > From: Chris Wright [mailto:chrisw@sous-sol.org]
> > I asked earlier, I didn't understand why it needs to be 2 fields, since
> > it's u32 in both cases and can't both be used at once.
> 
> We will look at seeing if we can make a single entry point that detects
> if it was called by 64b code, disable IA32e mode, and then jumps to the
> 32b code.

Yeah, that's exactly what I was thinking.  I assumed I missed a piece...

>   We did it this way initially because it was easier code to
> keep them separate and has been working for some time.  We'll also have
> to adjust Xen if/when we do this.

...which is just this ease of implementation, thanks.

thanks,
-chris
