Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZJYWSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZJYWSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 18:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZJYWSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 18:18:09 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41523 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZJYWSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 18:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WQdoq6E0PZx7Ar8pF1KRtuPElCHziLYhRFr1V12++d7XMiNIzbAy9FBFd083zXy/nL
         TwYF77HzRfw3MGkGRv/wynM1ZONXiMk0XfYHPAqXFRHQIFe6MbN9FzZZ9loWIxISFcJI
         b6JS4cTu+UQtooS8vW0RkLssahHvAFmX5gqXQ=
MIME-Version: 1.0
In-Reply-To: <1256078002-27919-1-git-send-email-linus.walleij@stericsson.com>
References: <1256078002-27919-1-git-send-email-linus.walleij@stericsson.com>
Date: Sun, 25 Oct 2009 23:18:12 +0100
Message-ID: <63386a3d0910251518i42149642g183f2d3f6c43384f@mail.gmail.com>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code 
	generic v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
       Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/21 Linus Walleij <linus.walleij@stericsson.com>:

> Changes v1->v2:
> - Fixed Mikaels comments: spelling, terminology.
> - Kept the functions inline: all uses and foreseen uses
>  are once per kernel and all are in __init or __cpuinit sections.
> - Unable to break out common code - the code is not common and
>  implementing two execution paths will be more awkward.
> - Hoping the tglx likes it anyway.

Ping on tglx on this, I will uninline the functions if you think
it's better in the long run, just tell me, else can you pick this
patch?

Linus Walleij
