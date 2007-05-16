Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbXEPXT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbXEPXT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXEPXTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:19:51 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:59136 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbXEPXTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:19:50 -0400
Message-ID: <464B9155.7070705@gentoo.org>
Date: Wed, 16 May 2007 19:18:45 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ed Sweetman <safemode2@comcast.net>
CC: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>, Duane Griffin <duaneg@dghda.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States
 driver
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <464B63D8.2060501@gentoo.org> <20070516212736.GO15763@ifa.hawaii.edu> <464B8819.3050303@comcast.net>
In-Reply-To: <464B8819.3050303@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Sweetman wrote:
> Like i mentioned off list, the problem here is that cpu freq modules 
> dont depend (Kconfig) on CONFIG_ACPI_PROCESSOR, yet they do.

Not really. Firstly, some of the cpufreq modules *do* depend on 
CONFIG_ACPI_PROCESSOR. Secondly, the ones that don't have an existing 
dependency do not actually depend on ACPI_PROCESSOR in some/most 
configurations.

I'll send in a patch to fix the real problem soon.

Daniel
