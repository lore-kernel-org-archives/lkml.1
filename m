Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbYCTWeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbYCTWeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbYCTWd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:33:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757729AbYCTWd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:33:58 -0400
Date: Thu, 20 Mar 2008 15:33:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: York Sun <yorksun@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       yorksun@freescale.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 2/2 v2] Add DIU platform code for MPC8610HPCD
Message-Id: <20080320153304.cdc1817d.akpm@linux-foundation.org>
In-Reply-To: <12059526271964-git-send-email-yorksun@freescale.com>
References: <12059526271941-git-send-email-yorksun@freescale.com>
	<12059526274026-git-send-email-yorksun@freescale.com>
	<12059526271964-git-send-email-yorksun@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 13:50:27 -0500
York Sun <yorksun@freescale.com> wrote:

> Add platform code to support Freescale DIU. The platform code includes
> framebuffer memory allocation, pixel format, monitor port, etc.
>
> ...
>
> +unsigned int mpc8610hpcd_get_pixel_format
> +	(unsigned int bits_per_pixel, int monitor_port)

Again, please do

unsigned int mpc8610hpcd_get_pixel_format(unsigned int bits_per_pixel,
					int monitor_port)

(and anywhere else where this was done)

> +int __init preallocate_diu_videomemory(void);

Nope, please don't put extern declarations in .c files.  Find a suitable
header for it - one which is included by the defining file and by all users
of the symbol.

Andy, checkpatch missed this.

>  }
>  #endif
> +

