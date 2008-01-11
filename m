Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbYAKViR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbYAKViR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbYAKViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:38:05 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46654 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760621AbYAKViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:38:04 -0500
Date: Fri, 11 Jan 2008 14:38:03 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080111213803.GS18741@parisc-linux.org>
References: <20080111114002.3e59d1ad@laptopd505.fenrus.org> <20080111194524.GA17170@suse.de> <20080111194931.GN18741@parisc-linux.org> <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org> <20080111201716.GO18741@parisc-linux.org> <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 01:28:30PM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 11 Jan 2008, Matthew Wilcox wrote:
> > 
> > Did I miss a bug report?  The only problems I'm currently aware of are
> > the ones where using MMCONFIG during BAR probing causes a hard lockup on
> > some Intel machines, and the ones where we get bad config data on some
> > AMD machines due to the configuration retry status being mishandled.
> 
> Hmm. Were all those reports root-caused to just that BAR probing? If so, 
> we may be in better shape than I worried.

I believe so.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
