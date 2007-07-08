Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbXGHJw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbXGHJw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 05:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbXGHJwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 05:52:20 -0400
Received: from mail.suse.de ([195.135.220.2]:50223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbXGHJwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 05:52:19 -0400
Date: Sun, 8 Jul 2007 11:52:06 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070708095206.GC7709@v2.random>
References: <20070706222651.GG5777@v2.random> <Pine.LNX.4.64.0707072053160.1536@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707072053160.1536@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 08:53:49PM +0200, Jan Engelhardt wrote:
> 
> On Jul 7 2007 00:26, Andrea Arcangeli wrote:
> >Subject: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
> 
> I wonder what happens if the soft page size gets set to 2048 bytes :)

Well the min allowed shift is 12 so you can't set it to 2048. But if
you're curious to see what happens, you can try removing the low limit
and force it to 11.. ;)
