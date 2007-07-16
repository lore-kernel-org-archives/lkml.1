Return-Path: <linux-kernel-owner+w=401wt.eu-S1765571AbXGPPpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765571AbXGPPpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbXGPPpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:45:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759514AbXGPPp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:45:29 -0400
Date: Mon, 16 Jul 2007 08:43:35 -0700
From: Greg KH <gregkh@suse.de>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/10] sysfs: fix kmem_cache_free(NULL)
Message-ID: <20070716154335.GA29449@suse.de>
References: <20070716134855.GA1858@APFDCB5C> <20070716135028.GA2040@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716135028.GA2040@APFDCB5C>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 10:50:28PM +0900, Akinobu Mita wrote:
> This patch fixes out of memory error handling in sysfs_new_dirent().
> kmem_cache_free() with NULL is not allowed.

Why not just allow kmem_cache_free() to allow NULL like other functions
in the kernel?

thanks,

greg k-h
