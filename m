Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbXIMHzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbXIMHzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXIMHzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:55:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46341 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbXIMHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:55:38 -0400
Date: Thu, 13 Sep 2007 01:55:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070913075536.GB17367@parisc-linux.org>
References: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com> <20070913073140.GA17367@parisc-linux.org> <1189668286.18361.3.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189668286.18361.3.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 03:24:46PM +0800, Shaohua Li wrote:
> On Thu, 2007-09-13 at 01:31 -0600, Matthew Wilcox wrote:
> > You missed the part where we have to avoid doing this for host bridges ...
> > 
> > http://marc.info/?l=linux-kernel&m=118809338631160&w=2
> > 
> > (I believe it's now queued in Greg's tree, and possibly Andrew's tree
> > too)
> Hmm, I don't know there is already a fix for this, so waste a whole
> morning :(. yes, your patch looks better.

Yes, this bug is causing a lot of people to waste time.  I fielded an
internal request for this patch this afternoon.  I appreciate we're
post-rc6 at this point, but it does rather suck to be releasing a kernel
which freezes on boot on this class of machines.

Unfortunately if this patch does cause any machine to break, these will
be machines that worked fine up until this point, so that would be a
regression, which is worse.  Life sucks.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
