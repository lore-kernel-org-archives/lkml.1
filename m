Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbYLIBiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbYLIBiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 20:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYLIBim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 20:38:42 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:18514 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYLIBil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 20:38:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a0vk4u5Sl6tBAzhmZyt8Vfi6SG88JlLgb5rdnDWmZdiF2M8HNx6OFsYHhUpQIUTIrW
         KU1L17ydXGE+NAptPhsCvd+Ut3pTkmpGqx1nrYbqI+ykvkYNhXaMPWyi8VOv+ZBXf5ae
         P2yXv7R3XXdTuEyLw6TXFkm8jKHwOLv4EfrFY=
Message-ID: <3aaafc130812081738o41c720f4kaf2a3ce611747b8@mail.gmail.com>
Date: Mon, 8 Dec 2008 20:38:39 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
Subject: Re: How to check for memory leaks
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530812081433o5125f08gb7cad0d33a1b4104@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <493D9D24.8080406@lwfinger.net>
	 <c62985530812081433o5125f08gb7cad0d33a1b4104@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 5:33 PM, Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 2008/12/8 Larry Finger <Larry.Finger@lwfinger.net>:
>> What is the best way to check if there is a memory leak?
>>
>> If I start a ping running on my system using the rtl8187 driver, and nothing

Is this the driver in the staging tree or a different one?

>> else active on my system, I see an increase in the "slab" value in /proc/meminfo
>> of about 65 kB/minute. Is this indicative of a memory leak? When I run the same
>> test with p54usb, the increase is only 20 kB/min.
>>
>> Thanks,
>>
>> Larry
>
>
> Hi,
>
> You could have a look on kmemleak: http://www.procode.org/kmemleak/
> It's up to date version is on the arm development git branch (topic kmemleak):
> http://www.linux-arm.org/git?p=linux-2.6.git;a=summary
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
