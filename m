Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbXBVU0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbXBVU0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXBVU0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:26:51 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:59096 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXBVU0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jl64teXcJSEI8WbbfxwOEYyfUYIPBDpNelPpY8TDy4FApZIDp0EJ2MQAgJWBhOAnWBNzdxt2JJmrVWaCVVg93XHPZ4++eNpNHUZBS4Pkvxy+IbtUyy1IkfgO0quyJLMUSQc2L98LkOPGUA/coMNfuEashhAiFynE2vSMaR2aQQk=
Message-ID: <d120d5000702221226i3afd0275h1045fd258e6800cb@mail.gmail.com>
Date: Thu, 22 Feb 2007 15:26:45 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: BUG: 2.6.20 atkbd spams console after kernel panic
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <45DDF1DF.4020408@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45DDF1DF.4020408@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Mark Lord <lkml@rtr.ca> wrote:
> The kernel panic is my fault, but I'd still like to see the on-screen
> messages when it happens.
>
> Unfortunately, 2.6.20 atkbd.c continuously spams the console after a
> kernel panic (my fault), with these messages:
>
> ...
> kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
> atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
> atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
> atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
> atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
> ...
>
> These appear to be getting generated in response to the flashing of the keyboard LEDs
> in response to the kernel panic.
>
> Could somebody fix this please?
>

Hi Mark,

Please try 2.6.21-rc1, it should be fixed properly there. If not
please let me know.

Thanks!

-- 
Dmitry
