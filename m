Return-Path: <linux-kernel-owner+w=401wt.eu-S965024AbXCALz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbXCALz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965025AbXCALz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:55:57 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47519 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965021AbXCALz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:55:57 -0500
Date: Thu, 1 Mar 2007 12:55:57 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] arch/i386/xen/: possible cleanups
Message-ID: <20070301115557.GC10921@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070301104817.GB10921@stusta.de> <45E6B0A1.8090106@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45E6B0A1.8090106@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 02:53:21AM -0800, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
>...
> >  struct shared_info *HYPERVISOR_shared_info = &init_shared;
> > -EXPORT_SYMBOL(HYPERVISOR_shared_info);
> 
> Are you sure?  I thought I added this because akpm was getting compile 
> errors with allmodconfig.

I don't see how this could be used in any modules in 2.6.20-mm2
(and the removal didn't result in any additional errors).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

