Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbXGFNzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbXGFNzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbXGFNze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 09:55:34 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1810 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbXGFNze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 09:55:34 -0400
Message-ID: <468E49C9.3000200@shadowen.org>
Date: Fri, 06 Jul 2007 14:55:21 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: [PATCH 1/3] GEODE: basic infrastructure support for AMD geode-class
 machines
References: <20070705160251.aea9aedc.dilinger@queued.net> <20070705152616.31c7c0d1.akpm@linux-foundation.org>
In-Reply-To: <20070705152616.31c7c0d1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> The patches have some trivial-but-common coding-style bloopers which
> scripts/checkpatch.pl will detect.  Please check it out.
> oh

> Please send a patch which documents mfgpt_irq in
> Documentation/kernel-parameters.txt, thanks.
> 
> Andy, the miss rate on documentation for new __setup() handlers is about
> 75%.  Might be worth adding to checkpatch.pl.

If we are willing to expect the update in the same patch then we can
emit a failure if the presented string in __check isn't in the update to
the documentation.  I guess emit it as a CHECK in case they have loads
of them and a separate documentation patch.

CHECK: __setup appears un-documented -- check
			Documentation/kernel-parameters.txt
#131: FILE: arch/i386/kernel/mfgpt.c:233:
+__setup("mfgpt_irq=", mfgpt_setup);

-apw
