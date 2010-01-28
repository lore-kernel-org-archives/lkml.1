Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983Ab0A1EXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0A1EXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 23:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836Ab0A1EXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 23:23:20 -0500
Received: from kroah.org ([198.145.64.141]:47562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab0A1EXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 23:23:19 -0500
Date: Wed, 27 Jan 2010 20:23:38 -0800
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][resend] set block size to PAGE_SIZE and some
	cleanups
Message-ID: <20100128042338.GA7004@kroah.com>
References: <1264602246-12880-1-git-send-email-ngupta@vflare.org> <1264602246-12880-4-git-send-email-ngupta@vflare.org> <4B610BA6.2020009@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B610BA6.2020009@vflare.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 09:29:34AM +0530, Nitin Gupta wrote:
> [replace stat_*() with rzs_stat*()]
> ---
> 
> ramzswap block size needs to be set to PAGE_SIZE
> to avoid receiving any unaligned block I/O (happens
> during swapon time). These unaligned access produce
> unncessary I/O errors, scaring users.
> 
> Also included some minor cleanups.

Such as?

Could you break this into 2 patches, one the block size stuff, and the
other the cleanups?  Remember, 1 patch does 1 thing.

thanks,

greg k-h
