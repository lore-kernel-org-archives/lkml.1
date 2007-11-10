Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbXKJPpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbXKJPpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXKJPoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:44:01 -0500
Received: from mail.suse.de ([195.135.220.2]:33029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbXKJPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:43:59 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 13/13] Char: nozomi, cleanup read and write
Date: Sat, 10 Nov 2007 16:43:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <151715551528512164.slaby@pripojeni.net>
In-Reply-To: <151715551528512164.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101643.57173.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:51:33, you (Jiri Slaby) wrote:
> nozomi, cleanup read and write
> 
> - remove macros testing for endianness, le*_to_cpu and complements will do
>   it
> - pointers cleanup (no need to have different pointers for be and le)
> - put unlikely into reading/writing while loop, because it will proceed
>   through this case only on last two bytes
> - also fix typos in write, le16_to_cpu instead of cpu_to_le16 for 2-byte
>   writes

Even though this looks much better it does not work :-(
With this patch applied the card goes "crazy". *sigh* I wish
i had more time today to look into this, but it probably
has to wait until next week on my side, sorry.
But i'll definitly have a close look into this.

Thanks so much for all this,
Frank


