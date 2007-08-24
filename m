Return-Path: <linux-kernel-owner+w=401wt.eu-S964931AbXHXAWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931AbXHXAWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763170AbXHXAWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:22:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:56245 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761860AbXHXAWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:22:33 -0400
Date: Thu, 23 Aug 2007 20:22:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/30] um: Don't unnecessarily cast allocation return value in ubd_kern.c
Message-ID: <20070824002217.GA11648@c2.user-mode-linux.org>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <9c32c87607b7e38a8bdfd5a9e536d42f259c7f64.1187912217.git.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c32c87607b7e38a8bdfd5a9e536d42f259c7f64.1187912217.git.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 01:43:49AM +0200, Jesper Juhl wrote:
> vmalloc() returns a void pointer, so casting to (void *) is pretty pointless.

Righto, I'll take care of this.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
