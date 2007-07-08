Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbXGHSlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbXGHSlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXGHSlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:41:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbXGHSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:41:12 -0400
Message-ID: <46912E09.2070806@zytor.com>
Date: Sun, 08 Jul 2007 11:33:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Drake <dsd@gentoo.org>, Jan Beulich <jbeulich@novell.com>,
       linux-kernel@vger.kernel.org, zwane@infradead.org,
       Andi Kleen <ak@suse.de>, "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org>
In-Reply-To: <20070708111404.1486e73c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> Well damn, we've let this slide for too long.
> 
> Guys, 2.6.22 is days away.  Do we think that the below is safe to merge
> now?
> 
> Add Daniel, this does fix things for you, doesn't it?
> 

The patch should be fine for 2.6.22, but for -mm, the code this patches
doesn't even exist with git-newsetup; nor is there a CONFIG_VIDEO_SELECT
which could impede the production of the VESA version.

What does your .config look like?

	-hpa
