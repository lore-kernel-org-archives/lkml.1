Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYK2Xwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYK2Xwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 18:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYK2Xwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 18:52:36 -0500
Received: from kroah.org ([198.145.64.141]:49187 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754554AbYK2Xwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 18:52:34 -0500
Date: Sat, 29 Nov 2008 15:49:07 -0800
From: Greg KH <greg@kroah.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Remi Colinet <remi.colinet@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org, linux-api@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Message-ID: <20081129234907.GA2340@kroah.com>
References: <1227980689.6354.24.camel@localhost.localdomain> <20081129214207.GA6747@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129214207.GA6747@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 12:42:07AM +0300, Alexey Dobriyan wrote:
> On Sat, Nov 29, 2008 at 06:44:49PM +0100, Remi Colinet wrote:
> > This patch add a new /proc/mempool file in order to display mempool usage.
> > 
> > The feature can be disabled with CONFIG_PROC_MEMPOOL=N during kernel
> > configuration.
> 
> We're NOT adding config option per proc file.
> 
> And can we, please, freeze /proc for not per-process stuff and open debugfs
> for random stuff, please?

debugfs has been open for random stuff since the day it was added to the
tree :)

Feel free to put this kind of thing there instead of proc.

thanks,

greg k-h
