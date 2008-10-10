Return-Path: <linux-kernel-owner+w=401wt.eu-S1763713AbYJJTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763713AbYJJTsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762011AbYJJTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:48:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761963AbYJJTsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:48:46 -0400
Date: Fri, 10 Oct 2008 12:42:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       pbadari@us.ibm.com, mel@csn.ul.ie, lcm@us.ibm.com, garyhade@us.ibm.com,
       mingo@elte.hu, greg@kroah.com, dave@linux.vnet.ibm.com,
       nish.aravamudan@gmail.com
Subject: Re: [PATCH 1/2] [REPOST] mm: show node to memory section
 relationship with symlinks in sysfs
Message-Id: <20081010124239.f92b5568.akpm@linux-foundation.org>
In-Reply-To: <20081009192115.GB8793@us.ibm.com>
References: <20081009192115.GB8793@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008 12:21:15 -0700
Gary Hade <garyhade@us.ibm.com> wrote:

> Show node to memory section relationship with symlinks in sysfs
> 
> Add /sys/devices/system/node/nodeX/memoryY symlinks for all
> the memory sections located on nodeX.  For example:
> /sys/devices/system/node/node1/memory135 -> ../../memory/memory135
> indicates that memory section 135 resides on node1.

I'm not seeing here a description of why the kernel needs this feature.
Why is it useful?  How will it be used?  What value does it have to
our users?


