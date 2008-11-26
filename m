Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYKZImO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYKZImO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYKZIl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:41:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:43331 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYKZIl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:41:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=uQShyf9jnslLNeCqmglOgsuHU+cgCy6s27s5N3/uQhFfAXmU4j+EK0ccXEgAmXiXGs
         EQgj2VqtDUGCDUwAt46fOycw05HWoFOoauSgljV/Kz5XKT5RJVTjWtBEY+JJv/qzZmWf
         HYFv501F2vfEMat4kP8B+QCyG4zofjGm1btuA=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 00/24] perfmon: introduction
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:41:55 -0800 (PST)
Message-ID: <492d0bd3.1ade660a.31f9.5137@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Repost with the correct cc: list]

Hello,

This series of patches implements the perfmon interface which provides access
to the hardware performance counters of modern processors. In particular,
this version supports per-thread counting for all AMD64 processors, and
recent Intel processors with architectural PMU (Core Duo, Core 2, Atom,
and Core i7).

It does not supersede Oprofile in this first implementation. Oprofile
and perfmon can be compiled in the same kernel, but only one can have
an active session at a time.

This implementation takes into account the various comments received from
previous reviews on LKML. This is a much simplified version compared to
the fully featured version maintained as a GIT tree on kernel.org.

This new version, named perfmon3, uses only 5 system calls (instead of 12).
Each call was carefully designed to allow for future extensions. 

Full documentation is available in Documentation/perfmon.txt and is provided
by one of the patches.

Once this basic set of perfmon functionalities is upstream, we will build
on it and add other features such as support for sampling, event set
multiplexing and other processor architectures.

Updated versions of libpfm and pfmon able to support both perfmon2 and
perfmon3 are available in the CVS repository on the perfmon web site, check
out: http://perfmon2.sf.net.

The patch series is against 2.6.28-rc6.

Please consider adding this patch series for 2.6.29 and send me any
comments you may have on the code.

Thanks to all the people who have contributed to this effort.

S.Eranian
-- 

