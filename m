Return-Path: <linux-kernel-owner+w=401wt.eu-S965427AbXDGGzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbXDGGzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 02:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965442AbXDGGzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 02:55:18 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46402 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbXDGGzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 02:55:16 -0400
Date: Fri, 6 Apr 2007 23:55:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] maps#2: Add /proc/pid/pagemap interface
Message-Id: <20070406235510.66115517.akpm@linux-foundation.org>
In-Reply-To: <13.469046093@selenic.com>
References: <1.469046093@selenic.com>
	<13.469046093@selenic.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 17:03:13 -0500 Matt Mackall <mpm@selenic.com> wrote:

> Add /proc/pid/pagemap interface
> 
> This interface provides a mapping for each page in an address space to
> its physical page frame number, allowing precise determination of what
> pages are mapped and what pages are shared between processes.

Could we please have a simple read-proc-pid-pagemap.c placed under
Documentation/ somewhere?  Also some sample output for the changelog
so we can see what all this does.

Also for kpagemap, please.

Should /proc/pid/pagemap and kpagemap be versioned?
