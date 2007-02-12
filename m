Return-Path: <linux-kernel-owner+w=401wt.eu-S1030189AbXBLWZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189AbXBLWZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030194AbXBLWZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:25:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030189AbXBLWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:25:14 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH x86 for review III] [17/29] x86: Add new CPUID bits for AMD Family 10 CPUs in /proc/cpuinfo
Date: Mon, 12 Feb 2007 23:23:53 +0100
User-Agent: KMail/1.9.5
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070212551.664370000@suse.de> <20070212165137.AD85913E1B@wotan.suse.de> <45D0E60F.2090506@redhat.com>
In-Reply-To: <45D0E60F.2090506@redhat.com>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122323.53364.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Since we seem to have become the place where all these are collected,
> shouldn't we document what they mean?

This is not a data sheet and the CPU vendors have fine tech writers
working on this already.

Also I don't really want to encourage people to hack this without
at least taking a basic look at the documentation first.

> I've got some this machine that 
> I'd like to know more about:
> 
> dts ss ds_cpl est tm2 ssse3 xtpr

All documented in Intel documentation. But it's all relatively boring stuff

dts = debug trace store
ss = self snoop
ds_cpl = cpl qualified debug store
est = enhanced speedstep
tm2 = thermal monitor 2
ssse3 = more sse3 instructions
xtpr = tpr register chipset update control msr

-Andi

