Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYH0Pev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYH0Pev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYH0Pem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:34:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbYH0Pel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:34:41 -0400
Date: Wed, 27 Aug 2008 08:28:48 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080827152848.GA19710@kroah.com>
References: <20080827000501.GA29570@kroah.com> <200808271056.37159.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808271056.37159.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 10:56:36AM +0200, Oliver Neukum wrote:
> Am Mittwoch 27 August 2008 02:05:01 schrieb Greg KH:
>  
> > I've now added this to my tree, and any review comments are greatly
> > welcome.
> 
> Unfortunately the issues are not trivial.

Nah, they are all easily fixable :)

> 1. USBTMC_SIZE_IOBUFFER
> use 2048. 4096 means a multipage allocation

So?  What difference does this really matter at normal USB speeds?

thanks,

greg k-h
