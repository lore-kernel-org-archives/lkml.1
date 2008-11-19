Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYKSIad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYKSIad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYKSIaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:30:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49156 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbYKSIaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:30:16 -0500
Message-ID: <4923CE85.3000206@cn.fujitsu.com>
Date: Wed, 19 Nov 2008 16:29:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       stable@kernel.org
Subject: Re: [PATCH] cgroups: fix a serious bug in cgroupstats
References: <4923CAF1.1020404@cn.fujitsu.com> <20081119002552.3840e3d2.akpm@linux-foundation.org>
In-Reply-To: <20081119002552.3840e3d2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch applies OK to 2.6.25, 2.6.26 and to 2.6.27.  I marked it as
> needing backport to those kernel versions.  Please let me know if that
> was inappropriate.
> 

Forgot to mention this:

The bug exists from 2.6.24 (when cgroupstats is introduced) to now, though
I didn't test in all those versions. I guess not many people used cgroupstats,
so it never gets triggered.

I think it can be applied to 2.6.24 too.
