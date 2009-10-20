Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbZJTWQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbZJTWQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 18:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZJTWQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 18:16:53 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36359 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZJTWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 18:16:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BWyLvb2x+26qEHNXClkdv2Yz9YaXFdN1fVm+lSqCGaLRYIW8XaZ2dxVjM5L44X6d0a
         yU3TiZkgst7exiiBH2VQvTkPJiLD5+hUcxKbIqmTPzr1bnBzBBWiT9kU776DWxOfTmdB
         fYmINKyPOQOw9YtWGg1M87o5BvUMv90QR5BjI=
MIME-Version: 1.0
In-Reply-To: <4ADE3225.5050001@caviumnetworks.com>
References: <1255819715-19763-1-git-send-email-linus.walleij@stericsson.com>
	 <alpine.LFD.2.00.0910200454300.2863@localhost.localdomain>
	 <4ADE3225.5050001@caviumnetworks.com>
Date: Wed, 21 Oct 2009 00:16:56 +0200
Message-ID: <63386a3d0910201516r71100657y92e3e6c2fab38db9@mail.gmail.com>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code 
	generic
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-mips@linux-mips.org, Mikael Pettersson <mikpe@it.uu.se>,
       Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/20 David Daney <ddaney@caviumnetworks.com>:

>> Please do not make that functions inline. They are too large and there
>> is no benefit of inlining them.
>
> If that is the case, then perhaps they should not be defined in a header
> file.

Of course not. There are apropriate places to put them, but as stated
I think the use as it is today warrants having them inlined.

Linus Walleij
