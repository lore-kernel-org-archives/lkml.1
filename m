Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbXEMSsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbXEMSsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXEMSr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:47:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33720 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642AbXEMSr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:47:56 -0400
Date: Sun, 13 May 2007 19:47:50 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       hch <hch@infradead.org>
Subject: Re: [PATCH 1/5] lguest host feedback tidyups
Message-ID: <20070513184750.GA4095@ftp.linux.org.uk>
References: <1178846246.23513.21.camel@localhost.localdomain> <1178846354.23513.23.camel@localhost.localdomain> <1179029245.23513.121.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179029245.23513.121.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 02:07:25PM +1000, Rusty Russell wrote:
> Most importantly, I now realize that Christoph's incorrect ranting
> about lgread_u32 et al was in fact a subtle ploy to make me diagnose
> the real issue: sparse 0.3 complains about casting a __user pointer
> to/from u32, but not an "unsigned long".  They are (currently)
> equivalent for lguest, but this is a much better solution than __force.

The real fix would be to declare it with u32 __user * as argument and deal
with callers.
