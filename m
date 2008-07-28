Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbYG1Upf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbYG1Upf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbYG1UpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:45:17 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:31664 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752446AbYG1UpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:45:14 -0400
Date: Tue, 29 Jul 2008 05:44:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/sh/maple/maple.c compile error
Message-ID: <20080728204438.GC20019@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>,
	Adrian McMenamin <adrian@mcmen.demon.co.uk>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080728202012.GD7713@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728202012.GD7713@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:20:12PM +0300, Adrian Bunk wrote:
> Commit 306cfd630a4d121cf4e08b894d8b4c4cf106e57e
> (maple: tidy maple_driver code by removing redundant connect/disconnect)
> causes the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/sh/maple/maple.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c: In function 'attach_matching_maple_driver':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:259: error: 'struct maple_driver' has no member named 'connect'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c: In function 'maple_detach_driver':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:272: error: 'struct maple_driver' has no member named 'disconnect'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:273: error: 'struct maple_driver' has no member named 'disconnect'
> make[4]: *** [drivers/sh/maple/maple.o] Error 1
> 
> <--  snip  -->
> 
Adrian was supposed to send follow-up patches for this, which never
happened. I thought I had dropped this already, but in this case I'll
just revert it.
