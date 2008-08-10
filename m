Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbYHJAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbYHJAsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYHJAsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:48:05 -0400
Received: from colo.lackof.org ([198.49.126.79]:38583 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbYHJAsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:48:04 -0400
Date: Sat, 9 Aug 2008 18:47:50 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 3/3] PCI: Add pci_read_base() API
Message-ID: <20080810004750.GA2617@colo.lackof.org>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx> <1217266741-26519-4-git-send-email-matthew@wil.cx> <20080804063833.GA21354@colo.lackof.org> <20080806143844.GL2055@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806143844.GL2055@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 08:38:45AM -0600, Matthew Wilcox wrote:
> On Mon, Aug 04, 2008 at 12:38:33AM -0600, Grant Grundler wrote:
> > On Mon, Jul 28, 2008 at 01:39:01PM -0400, Matthew Wilcox wrote:
> > > Some devices have a BAR at a non-standard address.  The pci_read_base()
> > > API allows us to probe these BARs and fill in a resource for it as if
> > > they were standard BARs.
> > 
> > Willy,
> > Can you add a comment to the code listing the offending device?
> > That way we know how to test next time this code changes.
> 
> It's not an offending device -- devices are allowed to put whatever they
> want anywhere outside the first 0x40 bytes of config space.

Sorry - bad phrasing on my part.

> Eric Anholt's patches add a user for this interface.

ok - people will find the "user" in the email archives now.

> If you want to see an
> example, download the Intel 3 Series Express Chipset Family Datashee
> (the filename is 316966.pdf) and see section 5.1.13 about the MCHBAR.

This would be a suitable comment in the code.
My point still stands: The next person modifying the code will
need to know how/what to test and where to look it up.

thanks,
grant
