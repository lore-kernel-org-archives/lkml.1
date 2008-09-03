Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYICXNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYICXNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 19:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYICXNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 19:13:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbYICXNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 19:13:38 -0400
Date: Wed, 3 Sep 2008 16:12:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: aaron@merfinllc.com, linux-kernel@vger.kernel.org, tytso@mit.edu,
       stable@kernel.org
Subject: Re: drivers/char/random.c line 728 BUG
Message-Id: <20080903161248.6f7ee1ff.akpm@linux-foundation.org>
In-Reply-To: <1220482297.17608.84.camel@calx>
References: <20080826225918.GC5452@merfinllc.com>
	<20080828225924.GD6432@merfinllc.com>
	<20080829124807.54293904.akpm@linux-foundation.org>
	<1220465901.17608.55.camel@calx>
	<20080903182845.GM17899@merfinllc.com>
	<1220479920.17608.62.camel@calx>
	<20080903153206.24dc88c3.akpm@linux-foundation.org>
	<1220482297.17608.84.camel@calx>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2008 17:51:37 -0500
Matt Mackall <mpm@selenic.com> wrote:

> Here's a more expansive version:
> 
> ___Avoid checking lock-protected entropy_count when lock isn't held. This
> fixes a bug reported by and diagnosed by Aaron Straus.
> 
> This fixes a regression introduced into 2.6.26 by
>  
>      commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
>      Author: Matt Mackall <mpm@selenic.com>
>      Date:   Tue Apr 29 01:03:07 2008 -0700
>  
>          random: simplify and rename credit_entropy_store

That regression already got fixed, and the fix is now in mainline and
is queued for 2.6.26.x.  So we would need a new rationale, please.

