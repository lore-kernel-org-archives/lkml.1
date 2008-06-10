Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYFJRIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYFJRIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYFJRIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:08:42 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:7178 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYFJRIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:08:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 00/18] PNP: convert resource options to unified dynamic list, v2
Date: Tue, 10 Jun 2008 11:08:10 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080604220933.168145536@ldl.fc.hp.com> <484DEE3D.7000705@keyaccess.nl>
In-Reply-To: <484DEE3D.7000705@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101108.11505.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008 09:00:13 pm Rene Herman wrote:
> On 05-06-08 00:09, Bjorn Helgaas wrote:
> 
> > This patch series converts the PNP resource option structures
> > to a unified linked list.  This preserves resource order, which
> > is important for some devices.  The bulk of the series is in
> > the last patch, and it has more a more detailed changelog.
> > 
> > Rene Herman did some testing of ISA devices and reviewed
> > v1 of this series.  I think I addressed all his comments.
> > Any comments would be welcome.
> > 
> > This depends on some patches that are in -mm, but not yet
> > upstream.  In mmotm, these would probably go after
> > pnp-dont-sort-by-type-in-sys-resources.patch
> 
> Perhaps it would've been different if I'd been a full-blown git wizzard 
> but this is getting rather painful to test against mainline. Would it be 
> possible for you to repost (privately or publicly) that which this 
> depends on against current mainline?

Sure.  Here's my current quilt "patches" directory:

http://www.kernel.org/pub/linux/kernel/people/helgaas/2.6.26-rc5-pnp1.tar.bz2
