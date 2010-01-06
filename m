Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508Ab0AFHSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0AFHSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672Ab0AFHSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:18:01 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:49453 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0AFHSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=l6s3Hq9JryBJXQU5zRFCAyzLujW05P50L4uHSjVHZp1Vd5uwoQZOeXvt9BXvyCma3p
         LsBoAsfkLoMm/e3T/0UyPlQXJ3qtT3OU2Dw+IADmFo2eo2bS4Uzc+ESasBKY9ZNUH89c
         jEStVYi2QNzz5ZlLUAhBfjG9hXCEJ+PIXMpPc=
MIME-Version: 1.0
In-Reply-To: <20100106071026.GD1382@ucw.cz>
References: <20100106071026.GD1382@ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 6 Jan 2010 15:17:39 +0800
Message-ID: <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com>
Subject: Re: sharp c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 3:10 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
> Sharp-SL code uses strange, complex grouping of gpios for wakeups
> toggling. Fortunately, it is unneeded in recent kernels (and actually
> provokes WARN_ONs during resume). Remove it.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Pavel,

The code to be removed below is used to support pxa27x_keypad
to be able to resume from sleep. What's the exact reason to remove
this on spitz?
