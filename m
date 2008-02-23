Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYBWSOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYBWSOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYBWSOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:14:42 -0500
Received: from testure.choralone.org ([194.9.77.134]:53973 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYBWSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:14:29 -0500
Date: Sat, 23 Feb 2008 13:14:14 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: modular intel-agp does not work on my box
Message-ID: <20080223181414.GA24313@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gabriel C <nix.or.die@googlemail.com>,
	Dave Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Gabriel C <crazy@frugalware.org>,
	Doug Thompson <dougthompson@xmission.com>
References: <47BE222B.2080500@googlemail.com> <alpine.DEB.0.82.0802220205410.3412@skynet.skynet.ie> <47BE32C7.5060008@googlemail.com> <47BE4125.3080503@googlemail.com> <20080222041921.GD21061@codemonkey.org.uk> <20080223000355.42219a89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223000355.42219a89.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:03:55AM -0800, Andrew Morton wrote:
 
 > >  > You are right without EDAC built , agp modular does work fine. I'm on 2.6.25-rc2-00477-g1a4c6be right now.
 > >  > So it is an EDAC bug ?
 > >  
 > > No, it's a failing of the pci driver model. It currently doesn't
 > > allow more than one driver to be bound to a single PCI device.
 > > For multi-function devices like bridges, this means we see problems
 > > like the one you mention.
 > 
 > Well that sounds pretty bad.  What will distros do about this?

either
*  ship both modular, and let the user decide which one he wants.
*  build just one of them (typically agp)
*  build them both, and let the above bug happen
*  build agp into the kernel, and edac modular, breaking edac
   for a minority.
 
 > Is there something short-term-and-sleazy we can do to "fix" it?

not that I'm aware of.  I think Greg has been working on a long-term fix.

	Dave

-- 
http://www.codemonkey.org.uk
