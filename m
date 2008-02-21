Return-Path: <linux-kernel-owner+w=401wt.eu-S934348AbYBUBVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348AbYBUBVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbYBUBV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:21:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:1549 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbYBUBV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:21:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,382,1199692800"; 
   d="scan'208";a="521992727"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 17:21:21 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201639.02502.jesse.barnes@intel.com> <b6a2187b0802201719x39a1298j970c563a17fe6a22@mail.gmail.com>
In-Reply-To: <b6a2187b0802201719x39a1298j970c563a17fe6a22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201721.21353.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 5:19 pm Jeff Chua wrote:
> On Thu, Feb 21, 2008 at 8:39 AM, Jesse Barnes <jesse.barnes@intel.com> 
wrote:
> >  Oops, maybe this should just be pci_choose_state instead.
> >  And this change should just be reverted (leave it as PCI_D0).
>
> drivers/char/drm/i915_drv.c: In function 'i915_suspend':
> drivers/char/drm/i915_drv.c:372: warning: passing argument 1 of
> 'pci_choose_state' from incompatible pointer type
> drivers/char/drm/i915_drv.c:373: warning: passing argument 1 of
> 'pci_choose_state' from incompatible pointer type
>
> I hope those are just warning that can just be ignored.

Oops again, should be dev->pdev.  Silly DRM layer obfuscation.

Jesse
