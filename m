Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbXE3Va0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbXE3Va0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbXE3VaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:30:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbXE3VaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:30:13 -0400
Message-ID: <465DECD7.8030104@zytor.com>
Date: Wed, 30 May 2007 14:29:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Linus Torvalds <torvalds@osdl.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GFP_DMA32 and PAE x86 machines
References: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com>
In-Reply-To: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> Just a question,
> 
> So we have GFP_DMA32 on x86-64 to gives us memory below 4G? so we not
> have the same on PAE based x86 machines so I can use a consistent API
> from the drm?
> 
> Otherwise it'll be stick some ifdefs in the drm to deal with it..
> 

Well, all lowmem is below 4 GB on i386...

	-hpa
