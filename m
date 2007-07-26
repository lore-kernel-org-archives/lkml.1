Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbXGZFk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbXGZFk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXGZFkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:40:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38003 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbXGZFkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:40:15 -0400
Date: Wed, 25 Jul 2007 22:42:31 -0700
From: Greg KH <greg@kroah.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       p.hardwick@option.com
Subject: Re: 2.6.23-rc1-mm1 - drivers/char/nozomi.c overflow in implicit
	constant conversion , warnings
Message-ID: <20070726054231.GB25147@kroah.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <46A7B59F.8070507@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A7B59F.8070507@googlemail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 10:42:07PM +0200, Gabriel C wrote:
> 
> ...
> 
> drivers/char/nozomi.c: In function 'interrupt_handler':
> drivers/char/nozomi.c:1298: warning: overflow in implicit constant conversion
> drivers/char/nozomi.c: In function 'nozomi_card_init':
> drivers/char/nozomi.c:1568: warning: overflow in implicit constant conversion
> drivers/char/nozomi.c:1592: warning: overflow in implicit constant conversion
> drivers/char/nozomi.c: In function 'nozomi_card_exit':
> drivers/char/nozomi.c:1673: warning: overflow in implicit constant conversion

Ick, yeah, that driver needs help.  Luckily someone is starting to work
on it now and help clean it up.

thanks for letting me know.

greg k-h
