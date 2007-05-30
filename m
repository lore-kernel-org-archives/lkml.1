Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbXE3WNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbXE3WNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbXE3WNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:13:41 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181AbXE3WNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:13:40 -0400
Message-ID: <465DF70C.9090408@zytor.com>
Date: Wed, 30 May 2007 15:13:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Linus Torvalds <torvalds@osdl.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GFP_DMA32 and PAE x86 machines
References: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com>	 <465DECD7.8030104@zytor.com> <21d7e9970705301507o2a89e824xdc6a980e8dbedaaf@mail.gmail.com>
In-Reply-To: <21d7e9970705301507o2a89e824xdc6a980e8dbedaaf@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> Depending on split all lowmem is below 1GB which isn't exactly
> optimal, I'd llike all 4GB for DMA.

Yes, but creating new memory zones is expensive.

	-hpa
