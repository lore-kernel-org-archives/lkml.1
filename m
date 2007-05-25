Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbXEYKqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbXEYKqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXEYKqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:46:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:47440 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761232AbXEYKp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mqpoKpdBbAp3agmR8EOalTHttm6UF7dOLOBEPAiVwZ3EhvJLMaQ88iMMhUvnQxurDY8qvG7uVmdqfTi9pm5fDYjlJVYkV9d3kCEDNoaiI4ZrMVaerCq0quip/uZ1TgHEN/rWgOcQRN1BmdkONR06nSz5NpsKVjs7gDLH1H4xzB8=
Message-ID: <84144f020705250345x4faa23f7kc6276017285357e8@mail.gmail.com>
Date: Fri, 25 May 2007 13:45:58 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] tty_io: Use kzalloc
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070525124258.5b72f077@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070525124258.5b72f077@hyperion.delvare>
X-Google-Sender-Auth: a99324c9f426a269
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 5/25/07, Jean Delvare <khali@linux-fr.org> wrote:
> -               ltp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
> +               ltp = (struct ktermios *) kzalloc(sizeof(struct ktermios),
>                                                  GFP_KERNEL);

When doing conversions like this, please drop the redundant casts too.
