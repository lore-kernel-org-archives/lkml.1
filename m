Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbXKJQPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbXKJQPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 11:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXKJQPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 11:15:37 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35692 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752046AbXKJQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 11:15:36 -0500
Date: Sat, 10 Nov 2007 17:15:12 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frank Seidel <fseidel@suse.de>
Subject: Re: [RFC 13/13] Char: nozomi, cleanup read and write
Message-ID: <20071110161511.GA21669@stusta.de>
References: <10551261882075921134.slaby@pripojeni.net> <151715551528512164.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <151715551528512164.slaby@pripojeni.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 06:51:35PM -0500, Jiri Slaby wrote:
>...
> --- a/drivers/char/nozomi.c
> +++ b/drivers/char/nozomi.c
>...
> -		if (size_bytes - i == 2) {
> +		if (unlikely(size_bytes - i == 2)) {
>...

Please don't add likely/unlikely in drivers unless it brings a 
measurable improvement.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

