Return-Path: <linux-kernel-owner+w=401wt.eu-S934858AbXLPREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbXLPREw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 12:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765954AbXLPREn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 12:04:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49401 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbXLPREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 12:04:42 -0500
Date: Sun, 16 Dec 2007 09:05:50 -0800
From: Greg KH <greg@kroah.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs: Revamp debugfs_create_{u,x,s}{8,16,32,64} to
	support signed integers
Message-ID: <20071216170550.GA12697@kroah.com>
References: <1197823079.7530.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197823079.7530.11.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 05:37:59PM +0100, Mattias Nissler wrote:
> This makes debugfs use its own file_operations for the value accessor files
> created by debugfs_create_XXX. Having that, we can also have proper versions
> for signed integers.

Why not tweak the "SIMPLE_ATTRIBUTE" code to support this instead?  That
way debugfs and all other filesystems could also use these attributes?

thanks,

greg k-h
