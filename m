Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbXJONhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbXJONhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758917AbXJONhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:37:37 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:24688 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbXJONhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LM10WhnSxhZBeTv2j+LCncTyi6R6+lUDRejI7ie6U2ltWuc9zLxkXBq1C6dUU/xvtNehgGZecl1ndmXceS1eWJWH6L7J/FNWJV+LzFA56+kH+y/wkBL3wFfO1N9r5NTacCQbOzXSlXlnz2P0iF3cAjTaayaR0xjCe1nGYf+38Mg=
Date: Mon, 15 Oct 2007 21:33:56 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, mb@bu3sch.de, st3@riseup.net,
       Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [-mm Patch] drivers/net/wireless/b43/main.c: fix an
	uninitialized variable
Message-ID: <20071015133356.GQ2444@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071014175142.GN4211@stusta.de> <20071015113445.GO2444@hacking> <20071015125644.GB5417@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015125644.GB5417@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 02:56:44PM +0200, Adrian Bunk wrote:
>On Mon, Oct 15, 2007 at 07:34:45PM +0800, WANG Cong wrote:
>> 
>> Fix an uninitialized variable in drivers/net/wireless/b43/main.c::b43_start().
>> 
>> From: Adrian Bunk <bunk@kernel.org>

Reported-by: Adrian Bunk <bunk@kernel.org>

>
>A technical remark regarding these two patches:
>
>These are your patches, not mine.
>
>You can note formally or informally that I reported/forwarded these 
>issues, but I'm neither in a legal sense the author of these patches nor
>am I in a technical sense responsible for their correctness [1], and a 
>From: tag is therefore not appropriate.
>

OK. I look through Jonathan's patch[1], but didn't find a proper tag
as you suggested. I think the "Reported-by:" tag may be appropriate,
as the above.

So, we need a "Reported-by:" tag, Jonathan. Could you please consider
to add it into your patch? I didn't see it in -mm1 tree or I can give
you a patch.

CC: Jonathan Corbet <corbet@lwn.net>

Thanks!

[1] http://lkml.org/lkml/2007/10/11/255

-- 
May the Source Be With You.
