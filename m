Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYBMMNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYBMMNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYBMMNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:13:43 -0500
Received: from zeus.pimb.org ([80.68.88.21]:2528 "EHLO zeus.pimb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYBMMNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:13:42 -0500
Date: Wed, 13 Feb 2008 12:13:32 +0000
From: Jody Belka <lists-lkml@pimb.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>,
       Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080213121332.GA7980@pimb.org>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2DBA5.6030001@goop.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Feb 13, 2008 at 10:59:33PM +1100, Jeremy Fitzhardinge wrote:
> Hi,
> 
> Although I'm on vacation, I happened to download a recent copy of 
> x86.git and found that it crashes early.  Here's a couple of patches to 
> apply; I don't know if they apply to current git, but I hope it helps.

> Subject: x86/early_ioremap: don't assume we're using swapper_pg_dir
> Subject: xen: unpin initial Xen pagetable once we're finished with it

Applying both of those to current git resulte in booting working again :)
Just leaves the halt/reboot issue that I posted a patch for in another thread.

Tested-by: Jody Belka <knew-linux@pimb.org>


J
-- 
Jody Belka
knew (at) pimb (dot) org
