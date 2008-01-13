Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYAMUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYAMUnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYAMUnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:43:13 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47803 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYAMUnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:43:11 -0500
Date: Sun, 13 Jan 2008 13:43:09 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Loic Prylli <loic@myri.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080113204309.GF18741@parisc-linux.org>
References: <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <20080112094557.71f5382a@laptopd505.fenrus.org> <478A5727.3000102@myri.com> <20080113104124.022cd0a5@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113104124.022cd0a5@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 10:41:24AM -0800, Arjan van de Ven wrote:
> Note: There is not a 100% overlap between "need" and "will not be used in 
> the patches that use legacy for < 256". In the other patches posted, 
> extended config space will be used in cases where it won't be with my 
> patch. (Most obvious one is an "lspci -vx" from automated scripts). 

I believe you to be mistaken in this belief.  If you take Ivan's patch,
conf1 is used for all accesses below 256 bytes.  lspci -x only dumps
config space up to 64 bytes; lspci -xxxx is needed to show extended pci
config space.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
