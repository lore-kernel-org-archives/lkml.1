Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXC0QtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXC0QtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXC0QtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:49:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:20841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933245AbXC0QtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:49:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,335,1170662400"; 
   d="scan'208"; a="64729144:sNHT18472860"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Greg KH <greg@kroah.com>
Subject: Re: Linux 2.6.21-rc5
Date: Tue, 27 Mar 2007 09:49:05 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>, Ben Dooks <ben-linux@fluff.org>,
       Dmitry Torokhov <dtor@mail.ru>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326221731.f4792260.akpm@linux-foundation.org> <20070327062042.GA29855@kroah.com>
In-Reply-To: <20070327062042.GA29855@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703270949.06130.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 26, 2007 11:20 pm Greg KH wrote:
> Already in Linus's tree.
>
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.2
> >1-rc5/2.6.21-rc5-mm2/broken-out/fix-sysfs-rom-file-creation-for-bios
> >-rom-shadows.patch
>
> I'd prefer to wait until 2.6.22 for this one, I've had too many odd
> reports of problems in this area, and since no one has reported this
> issue, it's not a real rush at all.

Yeah, I don't think this one is critical.  These files aren't in heavy 
use yet, so fixing this in 2.6.22 should be ok.  I've only heard one 
complaint about this bug so far, and that was caused by some code still 
in development.

Jesse
