Return-Path: <linux-kernel-owner+w=401wt.eu-S1761200AbXEULkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761200AbXEULkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbXEULjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:39:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:11309 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbXEULjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=U0GFWwKxfTxmufrx9sHHhJjkI0RxqJLX8znrFXXASy7IAVmC+COwhKq6x/2OrdOUny80FyYFgHNJ31jDJJpaC8ZXAIqUxhZaFOMdDH809NvLaOYbtKzJgOAwA8+s5JUifp7B1QeeTGD6SywJc0XRuQmY4HsPsxjoiYvRmu/5zgo=
Message-ID: <84144f020705210439q2a5cf03cr8bf673971ef53d42@mail.gmail.com>
Date: Mon, 21 May 2007 14:39:52 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <11797421843248-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179742180228-git-send-email-bryan.wu@analog.com>
	 <11797421843248-git-send-email-bryan.wu@analog.com>
X-Google-Sender-Auth: 16f3ba1a9f1aac53
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 5/21/07, Bryan Wu <bryan.wu@analog.com> wrote:
> +#ifdef CONFIG_DUMMY_CONSOLE
> +       conswitchp = &dummy_con;
> +#endif
>         cclk = get_cclk();
>         sclk = get_sclk();

This patch has no changelog. While it is probably apparent to you why
this fixes a crash when using an USB keyboard, it would be nice for
the rest of us to know which crash it fixes and why.
