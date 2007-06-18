Return-Path: <linux-kernel-owner+w=401wt.eu-S1763798AbXFRQaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763798AbXFRQaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbXFRQ36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:29:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46845 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353AbXFRQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:29:56 -0400
Date: Mon, 18 Jun 2007 09:29:15 -0700
From: Greg KH <greg@kroah.com>
To: Malte Cornils <malte@cornils.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       reiserfs-devel@vger.kernel.org, "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [1/2] 2.6.22-rc5: known regressions
Message-ID: <20070618162915.GA7440@kroah.com>
References: <467543E1.1060001@googlemail.com> <200706181302.42951.malte@cornils.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706181302.42951.malte@cornils.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 01:02:42PM +0200, Malte Cornils wrote:
> Hello,
> 
> Am Sonntag, 17. Juni 2007 16:23 schrieb Michal Piotrowski:
> > Here is a list of some known regressions in 2.6.22-rc5.
> > PCI
> >
> > Subject    : PCI setup hangs on Asus Notebook (nolapic helps)
> > References : http://lkml.org/lkml/2007/6/14/161
> > Submitter  : Malte Cornils <malte@cornils.net>
> > Status     : unknown
> 
> The original report was made on 2.6.22-rc3, I just checked and it still 
> happens on 2.6.22-rc5.

Can you use 'git bisect' to track down the patch that causes this to
fail?

thanks,

greg k-h
