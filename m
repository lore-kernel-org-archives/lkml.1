Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbYGYPwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbYGYPwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYGYPwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:52:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52334 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYGYPwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:52:03 -0400
Date: Fri, 25 Jul 2008 09:51:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Vrabel <david.vrabel@csr.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080725155146.GB17093@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <48807166.9010006@csr.com> <20080722155629.1160635e@brian.englab.brq.redhat.com> <200807221052.26879.jbarnes@virtuousgeek.org> <20080725152918.43bf3100@brian.englab.brq.redhat.com> <20080725134252.GG6701@parisc-linux.org> <20080725155329.79821436@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725155329.79821436@brian.englab.brq.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 03:53:29PM +0200, Michal Schmidt wrote:
> Maybe we should just not use MSI for devices without maskbits.

That seems excessive.  I wouldn't object to forbidding CPU affinity
changes for devices:

 - Without maskbits
 - With the intx quirk

I'd want to look into it in a bit more detail .... perhaps we could
allow irq affinity if we don't have to change the address, only the
data.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
