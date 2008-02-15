Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbYBOAl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbYBOAl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762203AbYBOAln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:41:43 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59309 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764987AbYBOAll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:41:41 -0500
Date: Fri, 15 Feb 2008 02:41:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove mca-pentium
Message-ID: <20080215004119.GJ23227@cs181133002.pp.htv.fi>
References: <20080214212337.GC23227@cs181133002.pp.htv.fi> <20080215002735.GA19937@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080215002735.GA19937@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 01:27:36AM +0100, Ingo Molnar wrote:
>...
> btw., it would be nice if someone could try a "smallest possible, but 
> still usable" x86 kernel.
> 
> the smallest one i could do, and which was still usable via the 
> networking, is the config below. It has a vmlinux of:
> 
>      text    data     bss     dec     hex filename
>   1330285  146512   69632 1546429  1798bd vmlinux
>...

"still usable" depends much on the use case - you might e.g. not have 
to bloat the kernel with CONFIG_BLOCK=y if it's for a machine without 
block devices.

> 	Ingo
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

