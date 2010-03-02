Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab0CBVGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:06:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46951 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0CBVGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O+t1XE4bZCRN1pakAzKw2ewKdjDJYvFUSI3wD1HC6l0I1jXzqLl6Ded6F66AcW7sPd
         gfS4A/X7TMVCM9A/fa1u7u8pFa9ZsyQ58y6fzV1MDGK/5cNhkB8Ri/BsRk9BuPDM9bMZ
         YkgqewIkvdj8XY7lEOB7FVyzIDv9xdWi9FxZc=
MIME-Version: 1.0
In-Reply-To: <1267560734-17001-1-git-send-email-linus.walleij@stericsson.com>
References: <1267560734-17001-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 2 Mar 2010 14:06:43 -0700
X-Google-Sender-Auth: 3bf40a99bf17a46b
Message-ID: <e9c3a7c21003021306w3546521dsd1ad50893f1ea44b@mail.gmail.com>
Subject: Re: [PATCH 1/5] DMAENGINE: COH 901 318 cleanups
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 1:12 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
>        if (cohc->nbr_active_done)
> +       /*
> +        * If another interrupt fired while the tasklet was scheduling,
> +        * we don't get called twice, so we have this number of active
> +        * counter that keep track of the number of IRQs expected to
> +        * be handled for this channel. If there happen to be more than
> +        * one IRQ to be ack:ed, we simply schedule this tasklet again.
> +        */
>                cohc->nbr_active_done--;

Checkpatch made a justifiable wimper about this.  It looks like you
wanted to delete that if() according to the previous unified patch?
