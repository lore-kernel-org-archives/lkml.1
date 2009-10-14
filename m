Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbZJOAEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbZJOAEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZJOAEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:04:07 -0400
Received: from kroah.org ([198.145.64.141]:50255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZJOAEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:04:05 -0400
Date: Wed, 14 Oct 2009 16:54:49 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: staging tree build failure
Message-ID: <20091014235449.GA9709@kroah.com>
References: <20091013150753.f738576e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013150753.f738576e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:07:53PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> make[4]: *** No rule to make target `include/linux/hayesesp.h', needed by `usr/include/linux/.install'.  Stop.
> 
> Caused by commit a724aa0a5ad2b3c6b5ee48e79a09e9fbc5cf3ec9 ("tty: esp:
> remove broken driver") which I have reverted for today.

I've now fixed this up, it needed to be removed from
include/linux/Kbuild file.

thanks,

greg k-h
