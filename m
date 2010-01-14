Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576Ab0ANEXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0ANEXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 23:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192Ab0ANEXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 23:23:14 -0500
Received: from kroah.org ([198.145.64.141]:56050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0ANEXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 23:23:13 -0500
Date: Wed, 13 Jan 2010 19:49:09 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before
	unlinking
Message-ID: <20100114034909.GB27634@kroah.com>
References: <1263388596.26006.1.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263388596.26006.1.camel@yio.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 02:16:36PM +0100, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: Driver-Core: devtmpfs - reset inode permissions before unlinking
> 
> Before unlinking the inode, reset the current permissions of possible
> references like hardlinks, so granted permissions can not be retained
> across the device lifetime by creating hardlinks, in the unusual case
> that there is a user-writable directory on the same filesystem.

Is this something that we need to worry about for existing users
(2.6.32 and .33), or can it wait until 2.6.34?

thanks,

greg k-h
