Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXLDSYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXLDSYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbXLDSYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:24:13 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46689 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXLDSYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:24:13 -0500
Message-Id: <20071204181845.895090222@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 04 Dec 2007 13:18:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] Linux Kernel Markers updates
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  4 Dec 2007 18:24:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The first patch in this patchset makes multiple marker users play together
nicely (SystemTAP, LTTng, blktrace...) by allowing multiple probes to be
connected to a single marker.

The second patch is used by SystemTAP to export the markers to a file using
modpost.

It would be interesting to consider getting these in soonish, so we can have
a stabilized marker API for 2.6.24.

This patchset applies on top of 2.6.24-rc4 in this order :

markers-support-multiple-probes.patch
linux-kernel-markers-create-modpost-file.patch

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
