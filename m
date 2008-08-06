Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYHFOpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYHFOpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHFOjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:39:03 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41465 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYHFOjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:39:02 -0400
Date: Wed, 6 Aug 2008 08:38:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 3/3] PCI: Add pci_read_base() API
Message-ID: <20080806143844.GL2055@parisc-linux.org>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx> <1217266741-26519-4-git-send-email-matthew@wil.cx> <20080804063833.GA21354@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804063833.GA21354@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 12:38:33AM -0600, Grant Grundler wrote:
> On Mon, Jul 28, 2008 at 01:39:01PM -0400, Matthew Wilcox wrote:
> > Some devices have a BAR at a non-standard address.  The pci_read_base()
> > API allows us to probe these BARs and fill in a resource for it as if
> > they were standard BARs.
> 
> Willy,
> Can you add a comment to the code listing the offending device?
> That way we know how to test next time this code changes.

It's not an offending device -- devices are allowed to put whatever they
want anywhere outside the first 0x40 bytes of config space.

Eric Anholt's patches add a user for this interface.  If you want to see an
example, download the Intel 3 Series Express Chipset Family Datashee
(the filename is 316966.pdf) and see section 5.1.13 about the MCHBAR.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
