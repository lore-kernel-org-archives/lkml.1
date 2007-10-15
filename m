Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbXJOWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbXJOWu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXJOWuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:50:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43179 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXJOWuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:50:20 -0400
Subject: Re: [PATCH 11/11] maps3: make page monitoring /proc file optional
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <12.290135367@selenic.com>
References: <12.290135367@selenic.com>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 15:49:59 -0700
Message-Id: <1192488599.6118.100.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 17:26 -0500, Matt Mackall wrote:
> 
> +config PROC_PAGE_MONITOR
> +       default y
> +       bool "Enable /proc page monitoring" if EMBEDDED && PROC_FS && MMU
> +       help
> +         Various /proc files exist to monitor process memory utilization:
> +         /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
> +         /proc/kpagecount, and /proc/kpageflags. Disabling these
> +          interfaces will reduce the size of the kernel by approximately 4kb. 

How about pulling the EMBEDDED off there?  I certainly want it for
non-embedded reasons. ;)

-- Dave

