Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYH2Wxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYH2Wxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYH2Wxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:53:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958AbYH2Wxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:53:30 -0400
Date: Fri, 29 Aug 2008 15:53:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dyn_array: using %pF instead of
 print_fn_descriptor_symbol
Message-Id: <20080829155319.dc76b1c0.akpm@linux-foundation.org>
In-Reply-To: <86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com>
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
	<20080829152053.92fa6fd4.akpm@linux-foundation.org>
	<86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>	ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
>	if (!ptr)
>		panic("Can not alloc dyn_alloc\n");

Why duplicate the panic()?  Just call __alloc_bootmem().

> #ifdef CONFIF_GENERIC_HARDIRQS

That doesn't appear to have been very well tested?

The code has a few coding-style glitches which checkpatch can detect.
