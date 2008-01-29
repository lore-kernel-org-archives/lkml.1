Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbYA2NRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbYA2NRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763305AbYA2NR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:17:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36333 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763277AbYA2NR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:17:26 -0500
Date: Tue, 29 Jan 2008 05:21:08 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: PCI x86: always use conf1 to access config space below 256
	bytes
Message-ID: <20080129132108.GD10761@kroah.com>
References: <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128223141.GA31101@parisc-linux.org> <20080128225334.GD4720@kroah.com> <20080129025615.GC20198@parisc-linux.org> <20080129025743.GD20198@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129025743.GD20198@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 07:57:44PM -0700, Matthew Wilcox wrote:
> PCI x86: always use conf1 to access config space below 256 bytes
> 
> Thanks to Loic Prylli <loic@myri.com>, who originally proposed
> this idea.
> 
> Always using legacy configuration mechanism for the legacy config space
> and extended mechanism (mmconf) for the extended config space is
> a simple and very logical approach. It's supposed to resolve all
> known mmconf problems. It still allows per-device quirks (tweaking
> dev->cfg_size). It also allows to get rid of mmconf fallback code.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Hm, who wrote this, Ivan?

If so, Matthew, please do not strip off authorship of patches, and place
a "From:" line on the first line above the description, so it is not
lost.

thanks,

greg k-h
