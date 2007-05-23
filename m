Return-Path: <linux-kernel-owner+w=401wt.eu-S1761176AbXEWWZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176AbXEWWZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760689AbXEWWYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:24:48 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:4358 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760673AbXEWWYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:24:46 -0400
Date: Thu, 24 May 2007 00:24:43 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Message-ID: <20070523222443.GA39776@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
	Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705231349.56976.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org> <200705231420.26622.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705231420.26622.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 02:20:23PM -0700, Jesse Barnes wrote:
> On Wednesday, May 23, 2007 1:56 pm Linus Torvalds wrote:
> > Ehh. Even for PCIe, why not use the normal accesses for the first 256
> > bytes? Problem solved.
> 
> Ok, this patch also works.  We still need to enable mmconfig space for 
> PCIe and extended config space, but we can continue to use type 1 
> accesses for legacy PCI config space cycles to avoid decode trouble 
> with mmconfig based BAR sizing.

Isn't that a mac-intel instant killer?  AFAIK they don't have type1,
period.

  OG.
