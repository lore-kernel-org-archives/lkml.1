Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbXFOKRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbXFOKRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbXFOKR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:17:27 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:3112 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbXFOKR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:17:26 -0400
Message-ID: <46726727.5090003@macroscoop.nl>
Date: Fri, 15 Jun 2007 12:17:11 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706071530.51552.jesse.barnes@intel.com> <4671992D.7060400@macroscoop.nl> <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706141625260.26236@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> That's strange, I guess different chipsets 'chew' up different amounts 
> of memory OR you have your DVT(?) (video-card memory/aperature) set to 
> 256MB? I have mine set to 128MB, in top:
>
> Mem:   8039576k total,  6187304k used,  1852272k free,      696k buffers
Me:
Mem:   7416672k total,   378988k used,  7037684k free,    13592k buffers

> What type of memory are you using 
2x Kingston KVR667D2N5K2/4G
> and what is your DVT set to?
GigaByte's BIOS config options of the onboard graphics controller are
very limited compared to those on your Intel motherboard.

I can only choose the graphics buffer size, between
"1MB+1~2MB for GTT" or "8MB+1~2MB for GTT".
I chose the latter. The POST says 9MB are taken for video.

Not that it matters much, as the current i810/intel xorg driver does
not yet support the GMA3100, so I'm using the vesa driver.

Thanks,
Pim

