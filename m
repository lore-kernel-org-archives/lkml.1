Return-Path: <linux-kernel-owner+w=401wt.eu-S965975AbXCPVxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965975AbXCPVxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965970AbXCPVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:53:09 -0400
Received: from [212.12.190.214] ([212.12.190.214]:32939 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965975AbXCPVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:53:07 -0400
From: Al Boldi <a1426z@gawab.com>
To: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org
Subject: Re: RSDL v0.31
Date: Sat, 17 Mar 2007 00:55:30 +0300
User-Agent: KMail/1.5
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703162325.05691.kernel@kolivas.org> <200703170040.48316.kernel@kolivas.org>
In-Reply-To: <200703170040.48316.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703170055.30747.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> Here are full patches for rsdl 0.31 for various base kernels. A full
> announce with a fresh -mm series will follow...
>
> http://ck.kolivas.org/patches/staircase-deadline/2.6.20.3-rsdl-0.31.patch

Thanks!  It looks much better now.

With X nice'd at -10, and 11 hogs loading the cpu, interactivity looks good 
until the default timeslice/quota is exhausted and slows down.  Maybe 
adjusting this according to nice could help.

It may also be advisable to fix latencies according to nice, and adjust 
timeslices instead.  This may help scaleability a lot, as there are some 
timing sensitive apps that may crash under high load.


Thanks!

--
Al

