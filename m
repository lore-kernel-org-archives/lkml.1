Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZGYTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZGYTvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 15:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZGYTvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 15:51:22 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:34608 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZGYTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 15:51:21 -0400
Date: Sat, 25 Jul 2009 20:51:16 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: annoying drivers/char/vr41xx_giu.c file still there
Message-ID: <20090725195115.GB1252@sucs.org>
Mail-Followup-To: Andrew Price <andy@andrewprice.me.uk>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Ralf Baechle <ralf@linux-mips.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0907230604180.3789@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907230604180.3789@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Thu, Jul 23, 2009 at 06:06:18AM -0400, Robert P. J. Day wrote:
> 
>   i thought someone was going to clean up this occasional git glitch:
> 
> $ git diff
> diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
> deleted file mode 100644
> index e69de29..0000000
> $
> 
>   that same diff output still pops up on occasion.  if you do a hard
> reset back to origin, it goes away but it will eventually reappear.

After some digging I found this:

http://git.kernel.org/?p=linux/kernel/git/ralf/linux.git;a=commit;h=ac01dc416905aeb331954d036287a0a0c5c90ec5

I read the thread that it references but there is no indication of
whether the empty file is going to be git rm'd any time soon.  Perhaps
Ralf could comment?

Andrew
