Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbXBWKMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbXBWKMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbXBWKMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:12:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60223 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbXBWKMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:12:52 -0500
Date: Fri, 23 Feb 2007 02:09:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, bunk@stusta.de, pavel@suse.cz,
       linux-pm@linux-foundation.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com, mingo@redhat.com
Subject: Re: 2.6.21-rc1: T60 resume from suspend to RAM issues
Message-Id: <20070223020904.c8fc8a3e.akpm@linux-foundation.org>
In-Reply-To: <20070222233803.GA4447@mellanox.co.il>
References: <20070222233803.GA4447@mellanox.co.il>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Feb 2007 01:38:03 +0200 "Michael S. Tsirkin" <mst@mellanox.co.il> wrote:
> I tested this:
> commit 9654640d0af8f2de40ff3807d3695109d3463f54
> and see 2 issues:
> 
> 1. After suspend to RAM, system wakes up but no screen.
> I can log in through ssh though.
> dmesg output at this point below.
> Works fine on 2.6.20 and below, with same .config
> .config and log file for this issue attached.
> 
> 2. As a separate test, I enabled DynTicks in .config.
> Seems to work fine but won't come out of suspend to memory at all:
> pressing Fn/F4 seems to have no effect.
> 

Do you believe that the second problem was caused by dynticks?
