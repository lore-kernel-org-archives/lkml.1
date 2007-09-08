Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbXIHQyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbXIHQyG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbXIHQxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:53:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54120 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXIHQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:53:53 -0400
Date: Sat, 8 Sep 2007 10:53:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070908165351.GA6809@parisc-linux.org>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <20070908095008.08eb4930.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908095008.08eb4930.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 09:50:08AM -0700, Randy Dunlap wrote:
> On 08 Sep 2007 18:07:00 +0200 Andi Kleen wrote:
> > This has also bitten me one or two times. A reasonable way would
> > be to just select SD automatically for !EMBEDDED
> 
> I'd say that someone needs to use a vendor kernel, or at least
> begin with a vendor .config file...

That's not entirely fair ... if you're switching over from a config
you've been dragging around for years which uses IDE rather than ATA,
it's far from obvious which config options you need to change.  I think
Andi's patch is a good one.  It might also be good to select SR (at
least my wife's laptop has the cd-rom on SATA).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
