Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbXIBATP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbXIBATP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 20:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXIBATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 20:19:04 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46869 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932231AbXIBATC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 20:19:02 -0400
Date: Sun, 2 Sep 2007 02:19:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH -mm] drivers/acpi/tables/tbutils.c: Shut up bogus
	uninitialized variable warning
Message-ID: <20070902001903.GC16016@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <alpine.LFD.0.999.0709020510300.20781@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709020510300.20781@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 05:12:14AM +0530, Satyam Sharma wrote:
> 
> drivers/acpi/tables/tbutils.c: In function 'acpi_tb_parse_root_table':
> drivers/acpi/tables/tbutils.c:403:
> warning: 'rsdt_address' may be used uninitialized in this function
> 
> has been verified to be a bogus warning. Let's just initialize the
> variable to zero and shut this up.
>...

Please use uninitialized_var() instead.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

