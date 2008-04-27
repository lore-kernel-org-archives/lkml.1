Return-Path: <linux-kernel-owner+w=401wt.eu-S1763700AbYD0TbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763700AbYD0TbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763287AbYD0TbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:31:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763007AbYD0TbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:31:08 -0400
Date: Sun, 27 Apr 2008 12:30:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 1/3] IPMI: Make comment match actual preprocessor check
Message-Id: <20080427123021.da84d98f.akpm@linux-foundation.org>
In-Reply-To: <20080421193430.GA13900@minyard.local>
References: <20080421193430.GA13900@minyard.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 14:34:30 -0500 Corey Minyard <minyard@acm.org> wrote:

> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> 
> Index: linux-2.6.24/include/linux/ipmi.h
> ===================================================================
> --- linux-2.6.24.orig/include/linux/ipmi.h
> +++ linux-2.6.24/include/linux/ipmi.h
> @@ -64,7 +64,7 @@
>   * applications and another for userland applications.  The
>   * capabilities are basically the same for both interface, although
>   * the interfaces are somewhat different.  The stuff in the
> - * #ifdef KERNEL below is the in-kernel interface.  The userland
> + * #ifdef __KERNEL__ below is the in-kernel interface.  The userland
>   * interface is defined later in the file.  */
>  

As sent, these three patches were purportedly authored by yourself.  But
they weren't.

Please put a From: line right at the very top of the changelog to
communicate the authorship, thanks.



