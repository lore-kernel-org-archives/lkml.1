Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbXK0JEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbXK0JEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXK0JE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:04:26 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:55734 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbXK0JEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=imVZtQ/IkWPAFdrx9sg+W+5JxyKc/RMDm+XvmpSXGN4ICl4cChAndbIf4Vcwb24gq95naLqa0sVQ16rb4AL1TYVZSpC/khHWZNKyD43mkRTN+5iDvXbfPHyNpwO5liK0NiK/GLnC1ckYWVmSE8eCrb27lbYyGBfU9fAhDaOdTZg=
Date: Tue, 27 Nov 2007 17:01:01 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [VIDEO]: Complement va_start() with va_end().
Message-ID: <20071127090101.GA2626@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071127065410.4293.71568.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127065410.4293.71568.sendpatchset@thinktank.campus.ltu.se>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 08:06:17AM +0100, Richard Knutsson wrote:
>Complement va_start() with va_end().
>
>Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
>---
>Compile-tested on i386 with allyesconfig and allmodconfig.
>
>
>diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
>index ad02329..996b494 100644
>--- a/drivers/media/video/saa5246a.c
>+++ b/drivers/media/video/saa5246a.c
>@@ -187,12 +187,14 @@ static int i2c_senddata(struct saa5246a_device *t, ...)
> {
> 	unsigned char buf[64];
> 	int v;
>-	int ct=0;
>+	int ct = 0;
> 	va_list argp;
>-	va_start(argp,t);
>+	va_start(argp, t);

Hi, Richard!

These are style fixes, and you did't mention this above. ;)

Thanks.


 Cong

