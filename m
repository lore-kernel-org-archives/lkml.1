Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYFCWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYFCWEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbYFCWEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:04:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758588AbYFCWD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:03:59 -0400
Date: Tue, 3 Jun 2008 15:03:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, menage@google.com
Subject: Re: [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
Message-Id: <20080603150346.4611b5ab.akpm@linux-foundation.org>
In-Reply-To: <4843AFC9.7000100@cn.fujitsu.com>
References: <4843AFC9.7000100@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 16:31:05 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> extract two functions from update_cpumask() and update_nodemask().They will be
> used later for updating tasks' cpus_allowed and mems_allowed after CPU/NODE
> offline/online.

Unfortunately this patch conflicts with
http://userweb.kernel.org/~akpm/mmotm/broken-out/cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch

Please check that the patch which I merged still makes sense.  ie: that
we did not revert the effects of that bugfix.

Thanks.

