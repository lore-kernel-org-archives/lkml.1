Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbXHBVM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbXHBVM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXHBVL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:11:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39275 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbXHBVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:11:55 -0400
Date: Thu, 2 Aug 2007 14:09:25 -0700
From: Greg KH <greg@kroah.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] debugfs helper for decimal challenged
Message-ID: <20070802210925.GA6199@kroah.com>
References: <200708011752.58481.rgetz@blackfin.uclinux.org> <20070801222523.GA26289@suse.de> <200708012313.51933.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708012313.51933.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 11:13:51PM -0400, Robin Getz wrote:
> From: Robin Getz <rgetz@blackfin.uclinux.org>
> 
> Allows debugfs helper functions to have a hex output, rather than just decimal
>  
> Signed-off-by:  Robin Getz <rgetz@blackfin.uclinux.org>
> ---
>  fs/debugfs/file.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)

You forgot to add the prototypes to the debugfs.h file so that people
can actually use these functions :)

Care to redo this?

> --- fs/debugfs/file.c	(revision 3529)
> +++ fs/debugfs/file.c	(working copy)

Oh, and add another level to the patch so it can be applied with "-p1"
by patch.

thanks,

greg k-h
