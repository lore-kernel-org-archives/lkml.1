Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYHOMse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYHOMse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYHOMs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:48:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:52179 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbYHOMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p4sdMal62SCn/FxsqMMZMh9xdaGL+FlymZXSgT4kXHcJmHPSyhLEFG+XS14AvPwqbx
         9pDHzJ4nxh8JbQjk70ZOgZAxuLTwrKZ6NPCwT4dCBysws8VSglUhPNscgefZHNusFneY
         bK1Nr5vfdIzvclmdXTpqVlXXoca/pIHEvOwEM=
Message-ID: <8bd0f97a0808150548s34f26232m2287664148668eb4@mail.gmail.com>
Date: Fri, 15 Aug 2008 08:48:25 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 1/1] MTD Maps: initial driver for using gpios to assist in addressing of parallel flash as is on the tinyboards
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1218792593.3184.71.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218789421-9995-1-git-send-email-cooloney@kernel.org>
	 <1218792593.3184.71.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 5:29 AM, David Woodhouse wrote:
> On Fri, 2008-08-15 at 16:37 +0800, Bryan Wu wrote:
>> +#define pr_devinit(fmt, args...) ({ static const __devinitconst char
>> __fmt[] = fmt; printk(__fmt, ## args); })
>
> You've added that macro twice in MTD code already -- and now you're
> adding it twice more (although I suspect only one was intentional).
> Where are we with putting it in include/linux/ where it belongs?

i havent tried since the last thread on the topic went nowhere.  guess
i could try again.
-mike
