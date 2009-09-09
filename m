Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZIILRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZIILRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZIILRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:17:19 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:57420 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZIILRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dfYxQwr4M3ub7yVbZUB8v6c83Dw9nF9RyE1MvWfNmdBSga7lhhwkT5CIYLpY2SXe2c
         yjlUfF9a4FTUue3fVFa6OKjgjIMvPQX7UooN7IcIPcRY/fN3ke8Nw54d6+txNChGBjKD
         dNoFVx+47TFXgBgkJ/jNvVmt+SCiGOnrzK3fQ=
MIME-Version: 1.0
In-Reply-To: <20090909093500.GC4292@sortiz.org>
References: <1251982396-23790-1-git-send-email-linus.walleij@stericsson.com>
	 <1251987348.6735.49.camel@odin>
	 <63386a3d0909081507n7071761fyb7c8350072129fcd@mail.gmail.com>
	 <20090909093500.GC4292@sortiz.org>
Date: Wed, 9 Sep 2009 13:17:18 +0200
Message-ID: <63386a3d0909090417l742cfa88u9747558c3e04d08d@mail.gmail.com>
Subject: Re: [PATCH 1/2] AB3100 regulator support v4
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/9 Samuel Ortiz <sameo@linux.intel.com>:

> On Wed, Sep 09, 2009 at 12:07:05AM +0200, Linus Walleij wrote:
>> 009/9/3 Liam Girdwood <lrg@slimlogic.co.uk>:
>>
>> > Samuel, are you happy for this to go via mfd for simpler merging ?
>> > If so :-
>> >
>> > Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
>>
>> OK with you Sam?
>
> Yes, applied to my for-next branch. There were a couple checkpatch 80+
> character line length warnings, but I'm not that picky :)

Thanks a lot Sam, I think all these warnings are of the type where
dev_*(); messages get more than 80 characters long, and that has
been indicated by Linus (the other one) and some subsystem maintainers
to be undesireable to break across lines in order to avoid hassles
when grep:ing for error strings in the kernel tree.

Linus Walleij
