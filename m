Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbYAKURa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbYAKURa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 15:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762482AbYAKURV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 15:17:21 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48992 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762419AbYAKURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 15:17:18 -0500
Date: Fri, 11 Jan 2008 13:17:16 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080111201716.GO18741@parisc-linux.org>
References: <20071225032605.29147200@laptopd505.fenrus.org> <20080111190229.GB10112@kroah.com> <20080111192820.GM18741@parisc-linux.org> <20080111114002.3e59d1ad@laptopd505.fenrus.org> <20080111194524.GA17170@suse.de> <20080111194931.GN18741@parisc-linux.org> <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 11:58:23AM -0800, Linus Torvalds wrote:
> On Fri, 11 Jan 2008, Matthew Wilcox wrote:
> > 
> > So your argument is that MMCONFIG sucks, therefore Linux has to have a
> > horrible interface to extended PCI config space?
> 
> What's *your* point?
> 
> MMCONFIG is known broken. If we ever start enabling it more (ie start 
> using it even if it's not reserved in the e820 tables), all that known 
> breakage will come and bite us in the *ss.

Ivan's patch doesn't start enabling MMCONFIG in more places than we
currently do.  It makes us use conf1 accesses for all accesses below
256 bytes.  That fixes all known problems to date.

> We need to have some armor-plated underwear to protect against that 
> ass-biting, and that's what Arjan's patch is. 
> 
> Tell me what *other* armor plating you could have that actually works?

The armour plating that already exists -- pci=nommconf.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
