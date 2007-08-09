Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXHIVYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXHIVYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXHIVYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:24:22 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:51514 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbXHIVYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:24:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=hG5ICLjty4OQpODYcYLnTZgBjGj7eKZNzdL1oVxKbopMR0mIwk9XnjOnybDq/
	uWIb31njq5cNqkAX+VLcywfdQ==
Date: Thu, 9 Aug 2007 23:24:18 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       Bryan Wu <bryan.wu@analog.com>, "H.PeterAnvin" <hpa@zytor.com>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] Add missing KERN_<level> to multiline printk(KERN_<level>...)
Message-ID: <20070809212418.GD20038@xi.wantstofly.org>
References: <1186619327.3073.57.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186619327.3073.57.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 05:28:46PM -0700, Joe Perches wrote:

> Some uses of printk are missing KERN_<level> on the second
> and subsequent lines.

I'm not the ARM maintainer, but for what it's worth,
the arch/arm/kernel/ecard.c change looks fine to me.

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
