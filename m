Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbYJUFvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbYJUFvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYJUFvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:51:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48970 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYJUFvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:51:24 -0400
Date: Mon, 20 Oct 2008 23:51:08 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: What's in pci-2.6.git
Message-ID: <20081021055107.GN26184@parisc-linux.org>
References: <200810081521.10262.jbarnes@virtuousgeek.org> <34A54798-E6AE-42E4-AAE3-D6C918971D69@qlogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34A54798-E6AE-42E4-AAE3-D6C918971D69@qlogic.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 10:18:38PM -0700, Anirban Chakraborty wrote:
> >Arjan van de Ven (1):
> >     PCI: introduce an pci_ioremap(pdev, barnr) function
> 
> Does it make sense to rename iounmap to pci_iounmap, just to be  
> consistent with pci_ioremap_bar?

iounmap can be used for ioremaps that aren't necessarily from PCI devices.
Since there's no length parameter to iounmap, there's nothing to get
wrong, so there's no natural counterpart to pci_ioremap().

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
