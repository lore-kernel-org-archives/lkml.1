Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZKBS1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZKBS1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932105AbZKBS1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:27:08 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:27023 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbZKBS1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:27:07 -0500
Date: Mon, 2 Nov 2009 11:27:07 -0700
From: Alex Chiang <achiang@hp.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: remove pci_find_slot from PCI_LEGACY config
	description
Message-ID: <20091102182707.GD5525@ldl.fc.hp.com>
References: <1256932009-5905-1-git-send-email-cascardo@holoscopio.com> <alpine.LSU.2.00.0911021648320.4203@wotan.suse.de> <20091102165608.GB20277@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102165608.GB20277@vespa.holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>:
> On Mon, Nov 02, 2009 at 04:49:01PM +0100, Jiri Kosina wrote:
> > On Fri, 30 Oct 2009, Thadeu Lima de Souza Cascardo wrote:
> > 
> > > Commit 3b073eda has removed pci_find_slot, so there's no point in
> > > mentioning it in the config description as one of the deprecated APIs
> > > there are enabled by PCI_LEGACY and still used by some drivers.
> > 
> > While you are at it, how about removing the references in 
> > Documentation/PCI/pci.txt as well?
> 
> I've hit them. But, on a first fast look, they seemed important
> historically. I will take a closer look and point that if it's proper or
> remove them entirely as you suggest.

I think you can safely remove the references to the APIs that are
no longer in the kernel at all, such as pci_find_slot(), etc.

On the other hand, if an interface is still there but deprecated,
you can leave it in Documentation/PCI/pci.txt.

Thanks,
/ac

