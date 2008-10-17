Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbYJQPF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbYJQPF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYJQPFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:11 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:17354 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYJQPFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=rHJ63A9wZhkp9RFJdsXYnntrmXAIUMMiC1MDpjBmIn28iIODRY1GieE5aaNFdtn4d6
         T5q3UR7M7spXQTyuthK2oHgtqeBK598k+XOjpi/i//k5cN6QRyWnx19XuwOpEi3Y7aon
         lj5QX3bxEU1GnCQg3lfN9QEAModG7YKNgf8i4=
To: linux-kernel@vger.kernel.org
Subject: [patch 00/24] perfmon3:  introduction
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:07 -0700 (PDT)
Message-ID: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series of patches implements the perfmon interface which provides access
to the hardware performance counters of modern processors. In particular,
this version supports per-thread counting for all AMD64 processors, and
recent Intel processors with architectural PMU (Core Duo, Core 2, Atom).

It does not supersede Oprofile in this first implementation. Oprofile
and perfmon can be compiled in the same kernel, but only one can have
an active session at a time.

This implementation takes into account the various comments received from
previous reviews on LKML. This is a much simplified version compared to
the fully featured version maintained as a separate GIT tree on kernel.org.

This new version, named perfmon3, uses only 5 system calls (instead of 12).
Each call was carefully designed to allow for future extensions. 

Full documentation is available in Documentation/perfmon.txt and is provided
by one of the patches.

Once this basic set of perfmon functionalities is upstream, we will build
on it and add other features such as support for sampling, event set
multiplexing and multi-architecture.

I will be releasing updated versions of libpfm and pfmon which can work
with this new API while continuing to work with the v2.x versions.

The patch series is against 2.6.27.

Please consider adding this patch series for 2.6.28.

Thanks to all the people who have contributed to this new release.

S.Eranian
-- 

