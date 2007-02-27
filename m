Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXB0BVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXB0BVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXB0BVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:21:18 -0500
Received: from terminus.zytor.com ([192.83.249.54]:39698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXB0BVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:21:16 -0500
Message-ID: <45E38762.5040407@zytor.com>
Date: Mon, 26 Feb 2007 17:20:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support
References: <20070223170527.4ca695b2@freekitty>	<Pine.LNX.4.61.0702262108010.23355@yvahk01.tjqt.qr> <20070226132834.70514f19@freekitty>
In-Reply-To: <20070226132834.70514f19@freekitty>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> 
> Hmm. Those are the GCC internal versions, that are picked up but
> doing divide in place. Do we want to allow general 64 bit in kernel to
> be easily used? It could cause sloppy slow code, but it would look
> cleaner.
> 

... and it would handle datatypes which may be architecture-dependent a 
lot cleaner.

I thought the motivation for div64() was that a 64:32->32 divide could 
be done a lot faster on a number of platforms (including the important 
x86) than a generic 64:64->64 divide, but gcc doesn't handle the 
devolution automatically -- there is no such libgcc function.

	-hpa
