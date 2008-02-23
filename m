Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbYBWIW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbYBWIW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932176AbYBWIJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:35 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763694AbYBWIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:26 -0500
Date: Sat, 23 Feb 2008 00:03:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Gabriel C <nix.or.die@googlemail.com>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: modular intel-agp does not work on my box
Message-Id: <20080223000355.42219a89.akpm@linux-foundation.org>
In-Reply-To: <20080222041921.GD21061@codemonkey.org.uk>
References: <47BE222B.2080500@googlemail.com>
	<alpine.DEB.0.82.0802220205410.3412@skynet.skynet.ie>
	<47BE32C7.5060008@googlemail.com>
	<47BE4125.3080503@googlemail.com>
	<20080222041921.GD21061@codemonkey.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 23:19:21 -0500 Dave Jones <davej@codemonkey.org.uk> wrote:

> On Fri, Feb 22, 2008 at 04:27:33AM +0100, Gabriel C wrote:
>  > Gabriel C wrote:
>  > > Dave Airlie wrote:
>  > >>> Hi,
>  > >>>
>  > >>> When building agp* modular ( CONFIG_AGP=y/m and CONFIG_AGP_INTEL=m ) intel-agp does nothing on my box 
>  > >>> ( Dell Precision WorkStation 530 MT ) chipset is not being detected.
>  > >>>
>  > >>> Building both Y fixes that and agpgart works and also detects my chipset.
>  > >> Have you got EDAC modules built as well? they might be taking ownership 
>  > >> when they shouldn't..
>  > >>
>  > > 
>  > > Yes I have EDAC built modular. I will build latest git without EDAC and agp modular
>  > > and let you know if that fixes ( workarounds ;) ) the problem.
>  > 
>  > You are right without EDAC built , agp modular does work fine. I'm on 2.6.25-rc2-00477-g1a4c6be right now.
>  > 
>  > So it is an EDAC bug ?
>  
> No, it's a failing of the pci driver model. It currently doesn't
> allow more than one driver to be bound to a single PCI device.
> For multi-function devices like bridges, this means we see problems
> like the one you mention.
> 

Well that sounds pretty bad.  What will distros do about this?

Is there something short-term-and-sleazy we can do to "fix" it?
