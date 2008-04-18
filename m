Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYDRXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYDRXyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYDRXyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:54:09 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:43854 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYDRXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:54:08 -0400
X-Greylist: delayed 1480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2008 19:54:07 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=dajH8B2NsQy/1cl5s6x8AsslEQ334XBzzl6cj/RjNS7ng6PZNdIEd+FKSce8+
	HKpz6H8z+ICv/9uzRGQDh/WzQ==
Date: Sat, 19 Apr 2008 01:29:22 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel@wantstofly.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
Message-ID: <20080418232922.GA31711@xi.wantstofly.org>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 07:22:45PM -0400, Jeff Garzik wrote:

> Avoid confusion by /not/ passing an unused pointer to
> arm_rtc_interrupt()

Looks OK to me.


> This change's main purpose is to prepare for the patchset in
> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
> never-used 'irq' argument in each interrupt handler.

What do you mean?  I know at least one of two interrupt handlers
in-tree that use their 'irq' arguments.
