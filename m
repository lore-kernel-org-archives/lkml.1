Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYHHGHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYHHGHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYHHGHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:07:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYHHGHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:07:21 -0400
Date: Thu, 7 Aug 2008 23:07:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 4/6] ia64 UV: Provide a LED driver for UV Systems
Message-Id: <20080807230700.bf5492d5.akpm@linux-foundation.org>
In-Reply-To: <20080808005658.554514000@polaris-admin.engr.sgi.com>
References: <20080808005639.505189000@polaris-admin.engr.sgi.com>
	<20080808005658.554514000@polaris-admin.engr.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2008 17:56:43 -0700 Mike Travis <travis@sgi.com> wrote:

>  * Add base functionality for writing to the LED's on
>     the ia64 UV architecture.
> 
> Note that this is a RAS feature that allows external monitoring of
> various cpu state indicators, not just providing "pretty blinking
> lights", as the LED state is readable by the system controller.
> 
> Based on linux-2.6.tip/master.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Tony Luck <tony.luck@intel.com>
> ---
>  arch/ia64/uv/kernel/setup.c  |    2 +
>  include/asm-ia64/uv/uv_hub.h |   61 ++++++++++++++++++++++++++++++++++++++++++-

It's arch/ia64/include/asm/uv/uv_hub.h in my kernel.  Weird.
