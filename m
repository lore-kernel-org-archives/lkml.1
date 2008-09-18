Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYIRPxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYIRPxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYIRPxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:53:33 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:41193 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbYIRPxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:53:32 -0400
Date: Thu, 18 Sep 2008 17:48:21 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Timur Tabi <timur@freescale.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmatest: properly handle duplicate DMA channels
Message-ID: <20080918174821.52b85b8b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48D27510.3060803@freescale.com>
References: <1221751279-24936-1-git-send-email-timur@freescale.com>
	<20080918173258.2640000b@hskinnemo-gx745.norway.atmel.com>
	<48D27510.3060803@freescale.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Sep 2008 15:48:11.0802 (UTC) FILETIME=[F46F8FA0:01C919A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> wrote:
> Haavard Skinnemoen wrote:
> 
> > ...though I don't really see why you have to use
> > list_for_entry_safe()...  
> 
> You use it in dmatest_remove_channel(), so I figured I'd do the same thing.

dmatest_remove_channel() may call list_del() on the current entry, so it
has to. As long as you're not altering the list, the _safe() variant
shouldn't be necessary.

Haavard
