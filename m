Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYGJPEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYGJPEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbYGJPDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:03:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44408 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbYGJPDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:03:42 -0400
Date: Thu, 10 Jul 2008 13:34:41 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH -mm 3/8] Hibernation: Simplify memory bitmap
Message-ID: <20080710113441.GC15412@elf.ucw.cz>
References: <200807100152.17755.rjw@sisk.pl> <200807100200.55473.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807100200.55473.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-07-10 02:00:54, Rafael J. Wysocki wrote:
> From: Akinobu Mita <akinobu.mita@gmail.com>
> Subject: Hibernation: Simplify memory bitmap
> 
> This patch simplifies the memory bitmap manipulations.
> 
> - remove the member size in struct bm_block
> 
> It is not necessary for struct bm_block to have the number of bit chunks
> that can be calculated by using end_pfn and start_pfn.
> 
> - use find_next_bit() for memory_bm_next_pfn
> 
> No need to invent the bitmap library only for the memory bitmap.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
