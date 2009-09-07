Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZIGMFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZIGMFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZIGMFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:05:19 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:36972 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbZIGMFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ihoUQKSeAfCv7Yrho/5CMV2E1NhnesHu6CV2jTwUCA70pRphmdQx1zT3CU5YcDiVej
         zEoWKSWEDTOcXKSXVe86Ox2bsgRLLMLGkRmIskh05EyRwpX7Y+eLmiLkaYAGLRawD1KN
         Cd/cchGkSNdtZ4CB+etwYwwDxBBLCdbZmRe4k=
MIME-Version: 1.0
In-Reply-To: <20090907110307.GK23450@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz>
	 <1252276145.17852.15.camel@dax.rpnet.com>
	 <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com>
	 <20090907110307.GK23450@elf.ucw.cz>
Date: Mon, 7 Sep 2009 16:05:19 +0400
Message-ID: <bc64b4640909070505v1f5e3e3ftcf4783188dbb78b4@mail.gmail.com>
Subject: Re: Zaurus suspend saga
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       omegamoon@gmail.com, eric.miao@marvell.com, utx@penguin.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 3:03 PM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi!
>
>> > I'd hate to see c) happen but I doubt I'm going to find time to rewrite
>> > that code any time soon and nobody else even seems to have grasped how
>> > deep this problem really is :(.
>>
>> Yeah, I'd agree that to rebuild the charger code on top of SPI, and possibly
>> as individual driver in the resume process (so order can be arranged) might
>> be the final solution, however, that's not an easy job indeed.
>
> Yep, zaurus is currently pretty broken; I don't think charging from
> Linux works at all, so I simply power down back to bootloader for
> charge.
>
> Anyway, suspend/resume is currently more important for me than charge,
> and I'd like to get at least that to work.
>
> Could we apply the trivial patch from "zaurus c3000 aka spitz: fix
> resume" , and preferably push it to linus for 2.6.31? One version
> where kernel suspends/resumes would be good.


I'd vote for it.

-- 
With best wishes
Dmitry
