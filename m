Return-Path: <linux-kernel-owner+w=401wt.eu-S933764AbXIUW6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbXIUW6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933038AbXIUWqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:46:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932953AbXIUWqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:46:35 -0400
Date: Fri, 21 Sep 2007 15:46:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Convert cpuinfo_x86 array to a per_cpu array
 v2
Message-Id: <20070921154622.c6920dcf.akpm@linux-foundation.org>
In-Reply-To: <20070920213004.781159000@sgi.com>
References: <20070920213004.527735000@sgi.com>
	<20070920213004.781159000@sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 14:30:05 -0700
travis@sgi.com wrote:

> cpu_data is currently an array defined using NR_CPUS. This means that
> we overallocate since we will rarely really use maximum configured cpus.
> When NR_CPU count is raised to 4096 the size of cpu_data becomes
> 3,145,728 bytes.

This has at least three quite obvious and careless compilation errors.

Please at least compile the code after you've altered it.
