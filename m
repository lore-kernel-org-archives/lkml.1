Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYHED64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYHED64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYHED6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:58:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:61251 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYHED6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iAhLfoCWZFxaEz0a4gYJ2Pvg1vGk5yXJzXAirzX/UOgCrGsD/oBKcMzXqMbtXRjtG1
         FHnYsYLQBSC4yMtcaaBq8C1kxjvhaJZMB6+ZGNmtwPspob9TpXOdSOj5ivbJiYsxwX21
         CYFw2ZFB2Xqn1IRJCPja/aTA/peO4RP0gLQ10=
Message-ID: <386072610808042058lf994767qd4c941d8dc13d7c8@mail.gmail.com>
Date: Tue, 5 Aug 2008 11:58:44 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: serial/bfin_5xx.c build error
Cc: sonic.zhang@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080802181624.GQ19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080802181624.GQ19682@cs181140183.pp.htv.fi>
X-Google-Sender-Auth: cbc46aa617cd522b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2008 at 2:16 AM, Adrian Bunk <bunk@kernel.org> wrote:
> Seems to be broken by Alan's changes:
>

I'm trying to locate the Alan's change, do you know it, Adrian?


> <--  snip  -->
>
> ...
>  CC      drivers/serial/bfin_5xx.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_set_ldisc':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:820: error: 'struct tty_ldisc' has no member named 'num'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c: In function 'bfin_serial_console_write':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1001: warning: comparison of distinct pointer types lacks a cast
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/bfin_5xx.c:1003: warning: comparison of distinct pointer types lacks a cast
> make[3]: *** [drivers/serial/bfin_5xx.o] Error 1
>
> <--  snip  -->

So is this bug in mainline upstream or linux-next latest tree?

Thanks
-Bryan
