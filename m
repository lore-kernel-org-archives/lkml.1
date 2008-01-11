Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbYAKV3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbYAKV3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760222AbYAKV3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:29:03 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760069AbYAKV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:29:01 -0500
Date: Fri, 11 Jan 2008 13:28:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <20080111211753.GR18741@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
References: <20080111190229.GB10112@kroah.com> <20080111192820.GM18741@parisc-linux.org> <20080111114002.3e59d1ad@laptopd505.fenrus.org> <20080111194524.GA17170@suse.de> <20080111194931.GN18741@parisc-linux.org> <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>
 <20080111201716.GO18741@parisc-linux.org> <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jan 2008, Matthew Wilcox wrote:
> 
> Did I miss a bug report?  The only problems I'm currently aware of are
> the ones where using MMCONFIG during BAR probing causes a hard lockup on
> some Intel machines, and the ones where we get bad config data on some
> AMD machines due to the configuration retry status being mishandled.

Hmm. Were all those reports root-caused to just that BAR probing? If so, 
we may be in better shape than I worried.

		Linus
