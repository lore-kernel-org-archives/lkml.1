Return-Path: <linux-kernel-owner+w=401wt.eu-S1760539AbZFQBCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbZFQBCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758431AbZFQBBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:01:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:41634 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZFQBBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:01:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,233,1243839600"; 
   d="scan'208";a="700028688"
Date: Wed, 17 Jun 2009 09:01:40 +0800
From: "Li, Yan I" <yan.i.li@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "greg@kroah.com" <greg@kroah.com>, yanli@infradead.org
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090617010138.GA13479@thyme.bj.intel.com>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"greg@kroah.com" <greg@kroah.com>, yanli@infradead.org
References: <20090615141613.GA7876@sage.bj.intel.com> <20090615143446.GB19451@srcf.ucam.org> <20090615144748.GA25734@thyme.bj.intel.com> <20090616154200.GA12715@srcf.ucam.org> <20090616173618.353901ee@lxorguk.ukuu.org.uk> <20090616164351.GA14353@srcf.ucam.org> <20090616181549.496ae0f2@lxorguk.ukuu.org.uk> <20090616171732.GA14912@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616171732.GA14912@srcf.ucam.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:17:32AM +0800, Matthew Garrett wrote:
> So the touchpad on these machines doesn't work with generic Windows? I'm 
> interested in the specifics, not general issues with i8042 
> implementations. We've repeatedly seen that these quirk tables end up 
> inadequately comprehensive and in several cases have masked the actual 
> problem.

Now we have more than 99% machines work well with current i8042 code
path, and less than 1% of machines (those MSI Wind & clones) that
don't work unless being added to this list.

If we do multiple-resetting unconditionally (for all machines), we are
effectively:
1. fixing things that works well
2. make >99% machines (the good citizens) untested

This seems a change too aggressive for me. Do we have a good reason
for taking this risk? 

Of course if we found the "actual problem" we'd conjure up a better
fix. But before that, I'd prefer the conservative way.

-- 
Best regards,
Li, Yan

Moblin Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net
