Return-Path: <linux-kernel-owner+w=401wt.eu-S1751076AbXDDUr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbXDDUr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXDDUr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:47:59 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:26604 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXDDUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YFA8d/D0aO3m39kGMc8dWkPQ1nIr/FFOfAdIa6ubD0t+G1TOrB1CxsrKTfLYG4cDV+5+fV+WpaHGZ8hY1M6BJFWE55pXdwF5Dne2bTtOVo30BbFoOvcDpNYnWSFWF/gGReq4SMntzEYC6DsZuP3m4aAYVfJi58HT99x2+xhDA2A=
Message-ID: <d120d5000704041347n3abec51cxa5859a0a191b38eb@mail.gmail.com>
Date: Wed, 4 Apr 2007 16:47:56 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Tony Lindgren" <tony@atomide.com>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Cc: linux-kernel@vger.kernel.org,
       "David Brownell" <dbrownell@users.sourceforge.net>
In-Reply-To: <11757100281957-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11757099691323-git-send-email-tony@atomide.com>
	 <11757100092910-git-send-email-tony@atomide.com>
	 <11757100112473-git-send-email-tony@atomide.com>
	 <11757100143517-git-send-email-tony@atomide.com>
	 <11757100163760-git-send-email-tony@atomide.com>
	 <11757100181189-git-send-email-tony@atomide.com>
	 <11757100214151-git-send-email-tony@atomide.com>
	 <11757100242980-git-send-email-tony@atomide.com>
	 <1175710026446-git-send-email-tony@atomide.com>
	 <11757100281957-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Tony Lindgren <tony@atomide.com> wrote:
> +
> +#ifdef CONFIG_LEDS
> +#define old_led_api()  1
> +#else
> +#define old_led_api()  0
> +#endif
> +
> +#ifdef CONFIG_LEDS_OMAP_DEBUG
> +#define new_led_api()  1
> +#else
> +#define new_led_api()  0
> +#endif
> +

Do we need that in mainline? Why would you not use led subsystem?

-- 
Dmitry
