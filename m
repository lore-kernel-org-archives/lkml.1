Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbXJVTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbXJVTGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXJVTG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:06:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:16140 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXJVTGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OVjKK4aeUfUE/ctBjENUp6hJ0NJPk2aRC/zfqnA1PMFiRK4LsFXE+jDXKxNUx7EsnWp9C467yvnwIBnf/D9OR3WABldwkeiAKSl3qao1cbeAFv46IRl79ZDkHYi23YdweiUwn+jCdsAO4IEMqzUbWDGkCFf7r2zPUlPXS5al+VY=
Message-ID: <471CF4AC.6060603@gmail.com>
Date: Mon, 22 Oct 2007 21:06:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: char/cyclades.c: inconsequent NULL checking
References: <20071022024734.GI30533@stusta.de>
In-Reply-To: <20071022024734.GI30533@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2007 04:47 AM, Adrian Bunk wrote:
> The Coverity checker spotted the following inconsequent NULL checking in 

Where can one obtain such a checker?

> drivers/char/cyclades.c:
> 
> <--  snip  -->
> 
> ...
> static void cyz_handle_tx(struct cyclades_port *info,
>                 struct BUF_CTRL __iomem *buf_ctrl)
> {
>         struct cyclades_card *cinfo = info->card;
>         struct tty_struct *tty = info->tty;
> ...
>                 if (tty == NULL)
>                         goto ztxdone;
> ...
>                 tty_wakeup(tty);
> ...
> 
> <--  snip  -->

patch on route, thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
