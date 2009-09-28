Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZI1SeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZI1SeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZI1SeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:34:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:42393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZI1SeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:34:09 -0400
Date: Mon, 28 Sep 2009 11:33:37 -0700
From: Greg KH <gregkh@suse.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix vt_compat_ioctl
Message-ID: <20090928183337.GA10855@suse.de>
References: <m2y6nzgcud.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2y6nzgcud.fsf@igel.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 08:10:02PM +0200, Andreas Schwab wrote:
> Call compat_unimap_ioctl, not do_unimap_ioctl.

That's a nice description of what the patch does, but why do we need to
do that?  What is the problem here?  What caused it?

thanks,

greg k-h
