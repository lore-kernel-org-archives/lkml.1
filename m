Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbXISHkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbXISHkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 03:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbXISHkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 03:40:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:44341 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbXISHkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 03:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t6NR6xs74N1b9vd4xOgRcrLEb0a3NAEkhuH3IPuwIx+xb8ggxAYtrwur7xWu5VNxAJsPOpq5JGo52Ys2tm7noqHKvBEsPpFRjGRnrm4SRz1eUIaqG3nIRK3NRciVoWtCFc77UZ3gxGm2X/TtC6Ri3XNRweMuvj+qv3p+PX+EdDc=
Message-ID: <8d6898730709190040r7dc5cb46m50b5d87b54facc63@mail.gmail.com>
Date: Wed, 19 Sep 2007 13:10:03 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Andrey Kamchatnikov" <andrey.kamchatnikov@tec-venture.de>
Subject: Re: Problem: one driver and 4 instances with different parameters
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <016a01c7fa89$ff51e850$b4fefea9@andrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <016a01c7fa89$ff51e850$b4fefea9@andrey>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think you need to modify your driver. So that you need to do only
single insmod. and handle the 4 instances internally.

On 9/19/07, Andrey Kamchatnikov <andrey.kamchatnikov@tec-venture.de> wrote:
> Hi,
>
> Could someone to make clear next question:
>
> I have one driver, but I need to run 4 instances of it (I run insmod with
> different parameters) .
>
> But when I try to install the second driver I've got an error, that driver
> with this name exists.
>
> How can I istall them? I don't want to use 4 different driver's sources.
>
> Thank you,
>
> Andrey
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
