Return-Path: <linux-kernel-owner+w=401wt.eu-S1767250AbXDTUfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767250AbXDTUfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767254AbXDTUex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:34:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:44257 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767246AbXDTUei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:34:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,433,1170662400"; 
   d="scan'208"; a="216853457:sNHT20794984"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI bridge range sizing bug
Date: Fri, 20 Apr 2007 13:34:55 -0700
User-Agent: KMail/1.9.6
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
References: <1175812632.17147.12.camel@localhost.localdomain> <200704200932.52181.jesse.barnes@intel.com> <alpine.LFD.0.98.0704201102000.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704201102000.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201334.56802.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 20, 2007 11:28 am Linus Torvalds wrote:
> On Fri, 20 Apr 2007, Jesse Barnes wrote:
> > Sounds good, hopefully reassigning the bridge resources won't cause
> > too much trouble.  Do you have time to hack this up?  If not, I
> > could give it a try, as long as ajax is willing to test...
>
> Actually, I would suggest we not do it automatically (because the
> need for it is just so low, and the downsides are potentially huge -
> there are just too many resources that are "hidden" from us through
> ACPI tricks and having hardware that doesn't actually expose their
> PCI resources fully through the normal PCI resource setup).

Yeah, that's probably prudent.  OTOH we should probably let the user 
know in no uncertain terms that some of the stuff behind one of their 
bridges will be inaccessible.

Thanks,
Jesse
