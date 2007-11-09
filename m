Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbXKILCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbXKILCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 06:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbXKILCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 06:02:30 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59904 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651AbXKILCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 06:02:30 -0500
Date: Fri, 9 Nov 2007 12:02:05 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux
	kernel [try #3]
Message-ID: <20071109110205.GZ26163@stusta.de>
References: <20071108041314.GG26163@stusta.de> <20071107174323.31820.65054.stgit@warthog.procyon.org.uk> <21923.1194530408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21923.1194530408@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 02:00:08PM +0000, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > The patch to include/asm-generic/Kbuild.asm doesn't seem to be required.
> 
> It is.  asm/a.out.h does not exist for MN10300, therefore the export process
> breaks unless it is told not to export this header.  The alternative is to
> move this line into each arch's individual header Kbuild file.
>...

Sorry, I confused include/asm-generic/Kbuild.asm with 
include/asm-generic/Kbuild .

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

