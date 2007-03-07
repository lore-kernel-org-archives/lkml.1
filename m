Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbXCGG5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbXCGG5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbXCGG5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:57:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51760 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859AbXCGG5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:57:19 -0500
Date: Tue, 6 Mar 2007 22:57:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, "tony.luck@intel.com" <tony.luck@intel.com>,
       rientjes@google.com,
       "kaneshige.kenji@soft.fujitsu.com" <kaneshige.kenji@soft.fujitsu.com>
Subject: Re: [BUGFIX][PATCH] fix NULL pointer in ia64/irq_chip-mask/unmask
 function
Message-Id: <20070306225710.f14ef163.akpm@linux-foundation.org>
In-Reply-To: <20070307152317.18159bdb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070306192718.999e114d.kamezawa.hiroyu@jp.fujitsu.com>
	<20070306030927.bc2f15fc.akpm@linux-foundation.org>
	<20070306203542.e9b3e133.kamezawa.hiroyu@jp.fujitsu.com>
	<20070307152317.18159bdb.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 15:23:17 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This patch fixes boot failure because irq_desc->mask() is NULL.
> 
> - Added mask/unmask functions to ia64's irq desc function table.
>   But I'm not sure this fix is correct or not. please review.
> 
> - rename hw_interrupt_type to irq_chip. hw_interrupt_type is old name.

Thanks.

This bug is present in mainline too, isn't it?
