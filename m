Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZHJXww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZHJXww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZHJXwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:52:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:46929 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZHJXwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VvxktMeKHZPI8rj54WVlFgswoaMXQu5nhDmYt0zqJUNqeuiiq35bQfmsfb9xHyqJtY
         saCJbV+eJWe+9t0l9YiJj1x4CqJYGjHX0Ejh+bg970TojW2JYtFQ6oaFoJgR77O75DVJ
         1reWL7iG1/ajSIaku+vL17L3BsdK6Q92qo+o8=
Message-ID: <4A80B2E6.2060706@gmail.com>
Date: Mon, 10 Aug 2009 16:53:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
In-Reply-To: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Fernando Planella Gonzalez wrote:
> Hi.
> I can't remember since when I've started seeing this, but since 2.6.23
> or 2.6.24, I think.
> Nowadays, I'm on Ubuntu 9.04, which is kernel 2.6.28.
> I'm flooded by the message: "do_IRQ: 0.91 No irq handler for vector"
> when in TTY.
> This is really annoying for text-base operation or in distros like
> sidux, where KDE watches syslog and shows a notification for every new
> line.
> Believe me, there are thousands of such notifications...
> Here is the dmesg results just after logging in:
> http://ubuntuforums.org/showpost.php?p=7759222&postcount=2 (yes, I've
> posted it in ubuntu forums with no succes ;)
> In this log, it's possible to see that the first time do_IRQ
> complains, it says: "do_IRQ: 0.99 No irq handler for vector". All
> others are for 0.91.
> I've tried adding the noirqbalance argument to kernel, and messed with
> everything related to IRQ in the BIOS with no success...
> Anybody, please help!!!
> --
> Luis Fernando Planella Gonzalez
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
have you tried the latest kernel with ubuntu,
or even the latest git head to see if this is fixed.

Justin P. Mattock
