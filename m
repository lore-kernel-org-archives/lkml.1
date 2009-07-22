Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZGVW2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZGVW2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZGVW2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:28:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbZGVW2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:28:18 -0400
Date: Wed, 22 Jul 2009 18:28:07 -0400
From: Dave Jones <davej@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
Message-ID: <20090722222807.GB20860@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org
References: <200907221926.50397.pavel@pavlinux.ru> <20090722213746.GA20241@redhat.com> <20090722231738.21de4deb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722231738.21de4deb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:17:38PM +0100, Alan Cox wrote:
 > On Wed, 22 Jul 2009 17:37:46 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > On Wed, Jul 22, 2009 at 07:26:49PM +0400, Pavel Vasilyev wrote:
 > >  > In the kernel configuration, if I choose x86_64 and PCI, then choose the item
 > >  > "Garth IOMMU support", which, in turn, chooses not to switch off, support for
 > >  > AGP. But many IOMMU system does not have AGP bus.
 > >  
 > > The lack of AGP slots doesn't mean a lack of AGP bus.
 > > It's part of the K8 on-CPU northbridge.
 > 
 > And the user is selecting CONFIG_AGP to select AGP devices rather than to
 > demonstrate their deep guru grade knowledge of K8 northbridges.

The user isn't selecting it at all. IOMMU is because it knows better than
the user.  "I'll turn this on for you, so that I don't corrupt your hard
disk when you load a video driver" seems eminently sensible to me.

 > Not only
 > that but CONFIG_AGP controls the display of AGP video card options so it
 > is a selection for offered devices not really an internal detail.

CONFIG_AGP has _nothing_ to do with video card options.
It's entirely about the aperture.

	Dave

