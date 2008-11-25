Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbYKYVgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbYKYVgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYKYVf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:35:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:45238 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYKYVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:35:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=xBU3TJcrpquwdROMk8H1wCic4dd0N4190EaIRJ9Bhflze5LmidN+ZpZbMnwkrKTHWN
         1Y9nIkxTRHE0uV0BR8IdwiW6zDixF89hmVHGXKMenVl7A8Un4GjqD5HmbpCjdrfoOhwG
         t6jC0Ro8J9BSpY3OWqCkFYsE9PNHZ0X1iUV8U=
To: linux-kernel@vger.kernel.org
Subject: [patch 00/24] perfmon: introduction
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:35:54 -0800 (PST)
Message-ID: <492c6fba.1c185e0a.15fb.6b71@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Please consider adding this patch series for 2.6.29.

Thanks to all the people who have contributed to this effort.

S.Eranian
-- 

