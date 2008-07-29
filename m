Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYG2Q3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYG2Q3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYG2Q3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:29:37 -0400
Received: from waste.org ([66.93.16.53]:53664 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbYG2Q3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:29:36 -0400
Subject: Re: [patch 1/4] Configure out AIO support
From: Matt Mackall <mpm@selenic.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       bcrl@kvack.org, linux-aio@kvack.org, akpm@linux-foundation.org
In-Reply-To: <20080729154747.574989775@free-electrons.com>>
References: <20080729154520.728594017@free-electrons.com> >
	  <20080729154747.574989775@free-electrons.com>>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 11:27:46 -0500
Message-Id: <1217348866.15724.148.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-29 at 17:45 +0200, Thomas Petazzoni wrote:
> plain text document attachment (configure-out-aio-support)
> This patchs adds the CONFIG_AIO option which allows to remove support
> for asynchronous I/O operations, that are not necessarly used by
> applications, particularly on embedded devices. As this is a
> size-reduction option, it depends on CONFIG_EMBEDDED. It allows to
> save ~7 kilobytes of kernel code/data:
> 
>    text	   data	    bss	    dec	    hex	filename
> 1115067	 119180	 217088	1451335	 162547	vmlinux
> 1108025	 119048	 217088	1444161	 160941	vmlinux.new
>   -7042    -132       0   -7174   -1C06 +/-
> 
> This patch has been originally written by Matt Mackall
> <mpm@selenic.com>, and is part of the Linux Tiny project.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: bcrl@kvack.org
> Cc: linux-aio@kvack.org
> Cc: mpm@selenic.com
> Cc: akpm@linux-foundation.org

These all look good to me, naturally.

Signed-off-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

