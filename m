Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbXFYSYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbXFYSYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXFYSYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:24:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:44277 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbXFYSYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:24:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,460,1175497200"; 
   d="scan'208";a="243161812"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Intel MTRR Patch
Date: Mon, 25 Jun 2007 11:23:22 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706241627130.5819@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706241627130.5819@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706251123.24194.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 24, 2007 1:27:46 Justin Piszcz wrote:
> Still patches clean against 2.6.22-rc5 incase anyone wanted to know:
>
> # patch -p1 < ../mtrr-v2.patch
> patching file Documentation/kernel-parameters.txt
> patching file arch/i386/kernel/cpu/mtrr/generic.c
> patching file arch/i386/kernel/cpu/mtrr/if.c
> patching file arch/i386/kernel/cpu/mtrr/main.c
> patching file arch/i386/kernel/cpu/mtrr/mtrr.h
> patching file arch/x86_64/kernel/bugs.c
> patching file arch/x86_64/kernel/setup.c
> patching file include/asm-x86_64/mtrr.h

I'm planning on releasing an updated version today, with the changes 
Eric pointed out were necessary (mainly not running it on non-Intel 
CPUs, since AMD maps high memory differently).  But it's good to see 
that the forward porting part of it will be easy. :)

I'm shooting for inclusion post 2.6.22, since I think the change is a 
bit too intrusive (mucking with early boot code) to push it before 
that.

Thanks,
Jesse
