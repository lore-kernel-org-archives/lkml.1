Return-Path: <linux-kernel-owner+w=401wt.eu-S934382AbZHENaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934382AbZHENaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934356AbZHENaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:30:15 -0400
Received: from kroah.org ([198.145.64.141]:33197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934346AbZHENaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:30:15 -0400
Date: Wed, 5 Aug 2009 06:29:14 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: tty tree build warning
Message-ID: <20090805132914.GA6054@kroah.com>
References: <20090805171606.d3d3877c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805171606.d3d3877c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 05:16:06PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (powerpc allyesconfig) produced this warning:
> 
> drivers/char/cyclades.c:3112: warning: initialization from incompatible pointer type
> drivers/char/cyclades.c:3118: warning: initialization from incompatible pointer type
> 
> Introduced by commit 46075a6e64b5e4e96079ea273781a1ba366d8244
> ("tty-cyclades-port-close").

Odd, I haven't changed anything there.  I'll check to see what happened.

thanks,

greg k-h
