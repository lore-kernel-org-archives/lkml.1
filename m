Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbXLQIza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbXLQIza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 03:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXLQIzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 03:55:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:52743 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXLQIzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 03:55:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rvC415p9gJl00hHTOMN35Owuvvg4XgLLsIAX+9if7v3kbVf7rwTzqeu7+Xcd8mtE4iD0IHjX1DCyPW7PgXhJnM47qt32TuaQP3Cml33VNQBQ/rlFUKB6fd3lFXkNkuBG4BVABTo+ZGoomDXcMnya5fUxcr79u0QgCHznVkFHMB8=
Message-ID: <cabda6420712170055j78da46c8x6af50b095e3447c0@mail.gmail.com>
Date: Mon, 17 Dec 2007 09:55:19 +0100
From: chri <chripell@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] max3100 driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47663726.3010508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197879438299-git-send-email-chripell@gmail.com>
	 <47663726.3010508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 9:45 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>
> You probably wanted to unregister it after _all_ cards are removed, not after
> each...
>

Hi,

thanks you are right. I haven't noticed this since spi devices are not
hot-pluggable so I could remove them only with rmmod (and so all of
them toghether). Anyway the code I sent is ugly, I will correct and
resend.

>
> Also you should synchronize_irq() after stopping them here.
>

I see. I guess I will have problems on suspending with serial activity
otherwise.

Thanks,


-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
