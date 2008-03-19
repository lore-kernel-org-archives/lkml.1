Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYCSTbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYCSTbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYCST0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:22 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:48493 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbYCST0R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:26:17 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <patchbomb.1205797011@localhost>
References: <patchbomb.1205797011@localhost>
Content-Type: text/plain; charset=utf-8
Date: Wed, 19 Mar 2008 09:22:45 +0000
Message-Id: <1205918565.4112.61.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-17 at 16:36 -0700, Jeremy Fitzhardinge wrote:
> Hi Ingo,
> 
> This is a great big pile of x86 unification and Xen bugfix patches.
> They build and boot for me on 64-bit and 32-bit (PAE and non-PAE).

FWIW I tested in a PAE Xen guest on 32 and 64 bit h/v and it was fine
including running ddcprobe which was my most recent issue. I can't see
why this would fix it though.

I thought for a second when you said it booted on 64 bit you meant 64
bit Xen guest, do you know how that stuff ﻿is going?

Ian.

> 
> Patches are based on x86.git#testing as of this morning.
> 
> The overview:
> 
>  - a couple of Xen bugfixes, which are 2.6.24 and 2.6.25 material
>  - a bunch of x86 cleanups and unifications, mostly around pgalloc
>  - some Xen fixes and improvements:
>    - unify PAE/non-PAE pagetable handling
>    - implement sysenter where applicable
> 
> Thanks,
> 	J
> 
> 
> 
-- 
Ian Campbell

  Evil isn't all bad.

