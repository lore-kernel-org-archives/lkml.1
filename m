Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbZD3Pfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbZD3Pfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763670AbZD3PfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:35:10 -0400
Received: from mga12.intel.com ([143.182.124.36]:61005 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763575AbZD3PfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:35:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,273,1239001200"; 
   d="scan'208";a="137769727"
Date: Thu, 30 Apr 2009 08:35:08 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Alex Buell <alex.buell@munted.org.uk>,
       Jeff Garzik <jeff@garzik.org>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
	question)
Message-ID: <20090430153508.GA10704@linux.intel.com>
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <49F95719.10701@kernel.org> <20090430144702.46415b90@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430144702.46415b90@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 02:47:02PM +0100, Alan Cox wrote:
> > So, at the point of driver load, there just isn't much we can do about
> > the missing ABAR.  It's sad.  Dunno why some laptop manufacturers
> > still program the thing into piix mode.  :-(
> 
> Forcing out of PIIX mode would need to go into the PCI quirks and be a
> boot option not a module one - at that point its doable as a header quirk.

I think Matthew Garrett already has code to do this.
