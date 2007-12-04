Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbXLDCtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbXLDCtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 21:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXLDCs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 21:48:58 -0500
Received: from mx1.suse.de ([195.135.220.2]:39878 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXLDCs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 21:48:57 -0500
From: Neil Brown <neilb@suse.de>
To: David Chinner <dgc@sgi.com>
Date: Tue, 4 Dec 2007 13:48:51 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18260.49171.818248.794797@notabene.brown>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression - 2.6.24-rc3 - umem nvram card driver oops
In-Reply-To: message from David Chinner on Tuesday December 4
References: <20071203213558.GP115527101@sgi.com>
	<18260.39892.215075.795664@notabene.brown>
	<20071204022015.GX119954183@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday December 4, dgc@sgi.com wrote:
> On Tue, Dec 04, 2007 at 11:14:12AM +1100, Neil Brown wrote:
> > On Tuesday December 4, dgc@sgi.com wrote:
> > > Neil,
> > > 
> > > I just upgraded an ia64 (Altix, 16k page size) test box to 2.6.24-rc3
> > > from 2.6.23 and I get it panicing on boot in the umem driver.
> > 
> > Cool - someone is using umem!  And even testing it.  Thanks!
> > 
> > A quick look shows a probable NULL deref.  Let me know if this fixes
> > it.  I'll read through the offending patch more carefully and make
> > sure there is nothing else wrong.
> 
> Yeah, that appears to fix the problem.
> 
> Tested-by: Dave Chinner <dgc@sgi.com>

Thanks. 
I couldn't find any other issues in the code.

NeilBrown
