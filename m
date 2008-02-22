Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbYBVETk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbYBVETk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYBVETc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:19:32 -0500
Received: from testure.choralone.org ([194.9.77.134]:52043 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYBVETb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:19:31 -0500
Date: Thu, 21 Feb 2008 23:19:21 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: modular intel-agp does not work on my box
Message-ID: <20080222041921.GD21061@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Gabriel C <nix.or.die@googlemail.com>,
	Dave Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Gabriel C <crazy@frugalware.org>
References: <47BE222B.2080500@googlemail.com> <alpine.DEB.0.82.0802220205410.3412@skynet.skynet.ie> <47BE32C7.5060008@googlemail.com> <47BE4125.3080503@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE4125.3080503@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 04:27:33AM +0100, Gabriel C wrote:
 > Gabriel C wrote:
 > > Dave Airlie wrote:
 > >>> Hi,
 > >>>
 > >>> When building agp* modular ( CONFIG_AGP=y/m and CONFIG_AGP_INTEL=m ) intel-agp does nothing on my box 
 > >>> ( Dell Precision WorkStation 530 MT ) chipset is not being detected.
 > >>>
 > >>> Building both Y fixes that and agpgart works and also detects my chipset.
 > >> Have you got EDAC modules built as well? they might be taking ownership 
 > >> when they shouldn't..
 > >>
 > > 
 > > Yes I have EDAC built modular. I will build latest git without EDAC and agp modular
 > > and let you know if that fixes ( workarounds ;) ) the problem.
 > 
 > You are right without EDAC built , agp modular does work fine. I'm on 2.6.25-rc2-00477-g1a4c6be right now.
 > 
 > So it is an EDAC bug ?
 
No, it's a failing of the pci driver model. It currently doesn't
allow more than one driver to be bound to a single PCI device.
For multi-function devices like bridges, this means we see problems
like the one you mention.

	Dave

-- 
http://www.codemonkey.org.uk
