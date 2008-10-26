Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbYJZUmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbYJZUmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 16:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYJZUmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 16:42:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:25734 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYJZUmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 16:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=APHZW6zM0jo5OXsx5aYRYnOkkVy0yhYiuWWHvmnLGbhvu4Yn4+ZUk2AFk7bQqggGOr
         AeC4PvwQ6IIYzVnyQEl0GLp7c5UGa4euI8RKTXSJ6ZGkbsXW6lsTNHE+ND6ITgYR4wGR
         JsSqiB+d7roRv3SyONHRZAi2pH0CtCrcrNjaw=
Date: Sun, 26 Oct 2008 23:45:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vlada Peric <vlada.peric@gmail.com>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de
Subject: Re: [PATCH] isdn: fix section mismatch warnings in isdn/hisax
Message-ID: <20081026204557.GA3295@x200.localdomain>
References: <6e4284620810261325n643cba26v129f2b076888bac9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e4284620810261325n643cba26v129f2b076888bac9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 09:25:25PM +0100, Vlada Peric wrote:
> -static int HiSax_inithardware(int *busy_flag)
> +static int __devinit HiSax_inithardware(int *busy_flag)

> -int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)
> +int __devinit hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct

Let's remove __devinit, not spread it.

	Alexey, who honestly tried to fix all section mismatches
		on fatconfig and miserably failed because after ISDN
		part took like 90% of resulting patch and the question
		whether root annotations are correct in the first place
		became louder and louder.
