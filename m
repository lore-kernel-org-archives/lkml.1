Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZGIRPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZGIRPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZGIRPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:15:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZGIRPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:15:16 -0400
Date: Thu, 9 Jul 2009 13:15:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090709171501.GA2991@infradead.org>
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <19028.31088.400461.939917@samba.org> <20090708130256.40957c3f@lxorguk.ukuu.org.uk> <19028.39145.180869.603673@samba.org> <20090708142510.5068b4c3@lxorguk.ukuu.org.uk> <19029.17896.769106.375379@samba.org> <20090709104228.7821e2f0@lxorguk.ukuu.org.uk> <1247147981.3898.15.camel@mulgrave.site> <20090709151009.07b2508b@lxorguk.ukuu.org.uk> <20090709152541.GA6334@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709152541.GA6334@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 11:25:41AM -0400, Theodore Tso wrote:
> Look, even if what you say is valid (despite the advice of lawyers),
> it is still useful for us to apply the patch (with the CONFIG option)
> in the upstream sources.  It means that support for the workaround
> stays in the mainstream sources, so we don't have to worry about
> separate patch going no longer applying as time goes by and the
> upstream sources change over time.  *If* a vendor really wants to
> strip out the source code, they can do that easily enough using
> unifdef to strip out the one specific CONFIG option.

By putting it in the kernel tree we would only give the bogus patent
claims more credit.  And so far no one has but IBM has actually care
about the patch.  Tridge can put the patch into the IBM kernel tree for
the service processors if you really deeply care, but can we leave the
rest of the world alone?

If someone really wants a patch to corrupt their filesystems they know
where to find it.
