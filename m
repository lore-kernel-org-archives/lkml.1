Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZDUAGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZDUAGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZDUAFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:05:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbZDUAFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:05:52 -0400
Date: Mon, 20 Apr 2009 17:01:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adriano dos Santos Fernandes <adrianosf@uol.com.br>
Cc: mingo@elte.hu, venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: memory_open cleanup - lookup minor device
 number from devlist
Message-Id: <20090420170155.9ff82860.akpm@linux-foundation.org>
In-Reply-To: <49EBF483.8000908@uol.com.br>
References: <49EBF483.8000908@uol.com.br>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 01:05:23 -0300
Adriano dos Santos Fernandes <adrianosf@uol.com.br> wrote:

> memory_open ignores devlist and does a switch for each item, duplicating 
> code
> and conditional definitions.
> 
> Clean it adding backing_dev_info to devlist and use it to lookup for the 
> minor
> device.

The patch looks reasonable, however your email client replaced all tabs
with spaces and I didn't really feel like fixing it all up.

I wonder what the lock_kernel() calls in memory_open() are doing.
