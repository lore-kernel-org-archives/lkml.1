Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZKSW3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZKSW3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 17:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZKSW3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 17:29:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:46728 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbZKSW3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 17:29:54 -0500
Subject: Re: [PATCH] LOCKSTAT: patch test - Fix min, max times in
 /proc/lock_stats
From: Peter Zijlstra <peterz@infradead.org>
To: frank.rowand@am.sony.com
Cc: mingo@redhat.com, tom.leiming@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <4B05BBAE.2050005@am.sony.com>
References: <4B05BBAE.2050005@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 23:29:55 +0100
Message-ID: <1258669795.11284.256.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 13:42 -0800, Frank Rowand wrote:
> Fix min, max times in /proc/lock_stats
> 
> (1) When collecting lock hold and wait times, if the current minimum time is
>     zero, it will be replaced by the next time.
> 
> (2) When aggregating minimum and maximum lock hold and wait times accross cpus,
>     the values are added, instead of selecting the minimum and maximum.
> 
> 
> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

Thanks Frank, took both patches.

