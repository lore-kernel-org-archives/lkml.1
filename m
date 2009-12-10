Return-Path: <linux-kernel-owner+w=401wt.eu-S1761316AbZLJRej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbZLJRej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761308AbZLJReh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:34:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:37376 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761306AbZLJReg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:34:36 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+ISlxwhOuIqhfG6l6n0CPST97kJHf2AGV0+IxH5U
	XuYxEuJrgdw75g
Date: Thu, 10 Dec 2009 18:35:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 0/3 v2] sh: fix dma driver
Message-ID: <Pine.LNX.4.64.0912101826010.4487@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further testing with preempt enabled revealed more problems with 
insufficient locking and improper descriptor state management. Therefore 
I'm resubmitting the

sh: fix DMA driver's descriptor chaining and cookie assignment

patch. At the same time I swapped it with stylistic changes, to put the 
complex stuff in the end. Also added a minor patch fixing comment in 
dmaengine.h. Patches

sh: DMA driver has to specify its alignment requirements
dmaengine: fix dmatest to verify minimum transfer length and test buffer size
sh: dmaengine support for sh7724

are not changed, so, not resubmitted

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
