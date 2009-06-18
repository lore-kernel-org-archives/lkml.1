Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZFRDhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZFRDhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZFRDgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:36:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbZFRDgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:36:52 -0400
Date: Thu, 18 Jun 2009 08:08:09 +0800
From: "Li, Yan" <yanli@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>, yan.i.li@intel.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090618000809.GB16835@thyme.bj.intel.com>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>, yan.i.li@intel.com,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"greg@kroah.com" <greg@kroah.com>
References: <20090615141613.GA7876@sage.bj.intel.com>
 <20090615143446.GB19451@srcf.ucam.org>
 <20090615144748.GA25734@thyme.bj.intel.com>
 <20090616154200.GA12715@srcf.ucam.org>
 <20090616173618.353901ee@lxorguk.ukuu.org.uk>
 <20090616164351.GA14353@srcf.ucam.org>
 <20090616181549.496ae0f2@lxorguk.ukuu.org.uk>
 <20090616171732.GA14912@srcf.ucam.org>
 <20090617010138.GA13479@thyme.bj.intel.com>
 <20090617025101.GA27595@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617025101.GA27595@srcf.ucam.org>
Organization: Intel
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SRS-Rewrite: SMTP reverse-path rewritten from <yanli@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 03:51:01AM +0100, Matthew Garrett wrote:
> On Wed, Jun 17, 2009 at 09:01:40AM +0800, Li, Yan I wrote:
> > This seems a change too aggressive for me. Do we have a good reason
> > for taking this risk? 
> 
> It's generally much easier to find regressions (people complain) than it 
> is to find things that have never worked (people just assume Linux is 
> broken).

That's true. But we are not sure how many regressions we'll meet and
whether the efforts devoted to handle them is worthy. (How to handle
regressions? Perhaps, ironically, we'll need another 'whitelist' for
them!)

> > Of course if we found the "actual problem" we'd conjure up a better 
> > fix. But before that, I'd prefer the conservative way.
> 
> Does stock Windows work on the machine? I think this really ought to be 
> a pretty obvious minimal test before adding quirks to the kernel.

Does this matter?  Does whether Windows fail or not affect our
decision here?  (Worse that I have no "stock Windows XP" for
testing. All I have are those companion Windows Recovery CDs that
include all drivers).

-- 
Li, Yan
