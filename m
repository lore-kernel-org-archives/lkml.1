Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbYAKT7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbYAKT7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761786AbYAKT73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:59:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761686AbYAKT73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:59:29 -0500
Date: Fri, 11 Jan 2008 11:58:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <20080111194931.GN18741@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>
References: <20071225032605.29147200@laptopd505.fenrus.org> <20080111190229.GB10112@kroah.com> <20080111192820.GM18741@parisc-linux.org> <20080111114002.3e59d1ad@laptopd505.fenrus.org> <20080111194524.GA17170@suse.de>
 <20080111194931.GN18741@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jan 2008, Matthew Wilcox wrote:
> 
> So your argument is that MMCONFIG sucks, therefore Linux has to have a
> horrible interface to extended PCI config space?

What's *your* point?

MMCONFIG is known broken. If we ever start enabling it more (ie start 
using it even if it's not reserved in the e820 tables), all that known 
breakage will come and bite us in the *ss.

We need to have some armor-plated underwear to protect against that 
ass-biting, and that's what Arjan's patch is. 

Tell me what *other* armor plating you could have that actually works?

		Linus
