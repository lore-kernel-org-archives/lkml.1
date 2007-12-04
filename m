Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbXLDCUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbXLDCUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 21:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXLDCUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 21:20:25 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56910 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751075AbXLDCUY (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 21:20:24 -0500
Date: Tue, 4 Dec 2007 13:20:15 +1100
From: David Chinner <dgc@sgi.com>
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression - 2.6.24-rc3 - umem nvram card driver oops
Message-ID: <20071204022015.GX119954183@sgi.com>
References: <20071203213558.GP115527101@sgi.com> <18260.39892.215075.795664@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18260.39892.215075.795664@notabene.brown>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 11:14:12AM +1100, Neil Brown wrote:
> On Tuesday December 4, dgc@sgi.com wrote:
> > Neil,
> > 
> > I just upgraded an ia64 (Altix, 16k page size) test box to 2.6.24-rc3
> > from 2.6.23 and I get it panicing on boot in the umem driver.
> 
> Cool - someone is using umem!  And even testing it.  Thanks!
> 
> A quick look shows a probable NULL deref.  Let me know if this fixes
> it.  I'll read through the offending patch more carefully and make
> sure there is nothing else wrong.

Yeah, that appears to fix the problem.

Tested-by: Dave Chinner <dgc@sgi.com>

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
