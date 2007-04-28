Return-Path: <linux-kernel-owner+w=401wt.eu-S1163408AbXD1SIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163408AbXD1SIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163407AbXD1SIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:08:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53007 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163399AbXD1SIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:08:02 -0400
Message-ID: <46338D72.70402@garzik.org>
Date: Sat, 28 Apr 2007 14:07:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable
 bzImage
References: <20070428758.455116000@suse.de> <20070428175909.1D09D151CA@wotan.suse.de>
In-Reply-To: <20070428175909.1D09D151CA@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Vivek Goyal <vgoyal@in.ibm.com>
> 
> 
> o Extend the bzImage protocol (same as i386) to allow bzImage loaders to
>   load the protected mode kernel at non-1MB address. Now protected mode
>   component is relocatable and can be loaded at non-1MB addresses.
> 
> o As of today kdump uses it to run a second kernel from a reserved memory
>   area.
> 
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> Signed-off-by: Andi Kleen <ak@suse.de>

Can you point to / link to threads where the bootloader folks looked 
over the reloc changes from their side, and commented?

	Jeff



