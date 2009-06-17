Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZFQQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZFQQgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZFQQgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:36:04 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36125 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZFQQgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:36:02 -0400
Date: Wed, 17 Jun 2009 10:36:04 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Alex Chiang <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: linux-next: Tree for June 17 (pci/slot)
Message-ID: <20090617163604.GT19977@parisc-linux.org>
References: <20090617155354.075c60ae.sfr@canb.auug.org.au> <4A39194B.2060200@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A39194B.2060200@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 09:26:51AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090616:
> 
> 
> When CONFIG_SYSFS=n:
> 
> drivers/pci/slot.c:327: error: 'module_kset' undeclared (first use in this function)

Is there any point to pci_slot existing without CONFIG_SYSFS?
I don't see how you can interact with it in any meaningful way.
Perhaps CONFIG_PCI_SLOT should depend on CONFIG_SYSFS?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
