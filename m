Return-Path: <linux-kernel-owner+w=401wt.eu-S935348AbYD1P04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348AbYD1P04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933406AbYD1P0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:26:46 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:30702 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbYD1P0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:26:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 21/54] PNP: add debug when assigning PNP resources
Date: Mon, 28 Apr 2008 09:25:56 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183928.375529075@ldl.fc.hp.com> <48139DFC.500@keyaccess.nl>
In-Reply-To: <48139DFC.500@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804280925.56771.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008 03:26:20 pm Rene Herman wrote:
> On 25-04-08 20:38, Bjorn Helgaas wrote:
> > +#else
> > +void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
> > +{
> > +}
> > +#endif
> 
> Not too important, but #ifdef could be inside body.

Much nicer, thanks.

I'll add your updates and acks and repost this series today.

> > +		dev_dbg(&dev->dev, "  io %d already set to 0x%llx-0x%llx "
> > +			"flags 0x%x\n", idx, (unsigned long long) *start,
> > +			(unsigned long long) *end, (int) *flags);
> 
> I wanted to ask/comment why you're casting the flags to int though. It's an 
> unsigned long, both in the resource and by type here. Ie, 0x%lx and no 
> casting? (I btw also like %#lx better then the explicit 0x, but that doesn't 
> really matter).

Two more good ideas.  The cast was just me not paying attention, and
the "0x%x" habit is deeply ingrained.  I'll change both.

Bjorn

