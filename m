Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbXKHSHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbXKHSHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbXKHSHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:07:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759962AbXKHSHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:07:32 -0500
Date: Thu, 8 Nov 2007 10:06:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH (2.6.25) 1/2] hibernation: clean up Kconfig
Message-Id: <20071108100618.40e6c0af.akpm@linux-foundation.org>
In-Reply-To: <1194543003.4793.19.camel@johannes.berg>
References: <20071107135758.100171000@sipsolutions.net>
	<200711072317.48023.rjw@sisk.pl>
	<1194533053.6294.42.camel@johannes.berg>
	<20071108092149.e27c5ba3.akpm@linux-foundation.org>
	<1194543003.4793.19.camel@johannes.berg>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 08 Nov 2007 18:30:03 +0100 Johannes Berg <johannes@sipsolutions.net> wrote:
> This cleans up the hibernation Kconfig and removes the need to
> declare centrally which architectures support hibernation. All
> architectures that currently support hibernation are modified
> accordingly.
> 
> ...
>
>  arch/powerpc/Kconfig |   14 ++++++++++++--
>  arch/x86_64/Kconfig  |    3 +++
>  kernel/power/Kconfig |   18 +++---------------

I assume this was against 2.6.23.  Please, it's not very useful to prepare
patches against such an old kernel.  Even if the receiver were to fix te
patch up, there isn't much confidence that it will actually work at
compile-time and runtime.

