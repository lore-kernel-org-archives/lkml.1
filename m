Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXDIULc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXDIULc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXDIULc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:11:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:8108 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485AbXDIULb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KjiIC3FejIz942Zrd9dPWhrDUuYVszpt0TlvTs1BxELNhShlDSrGNwbZBiA8gRN/lfAJXMdRLqXjASk0XzTwAZmxG+iNafFfgM3JFLRe0uN3Om6tGDlsgupRpym1KIeYts7UMMfHr8GnLy6JQPmyKXe2fIZbvAYqjNbrvgvN7YI=
Message-ID: <d120d5000704091311g28daf72dyc68bf55eb45c8da2@mail.gmail.com>
Date: Mon, 9 Apr 2007 16:11:24 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Apple SMC driver - fix input device
Cc: "Nicolas Boichat" <nicolas@boichat.ch>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, rlove@rlove.org, linux-kernel@hansmi.ch,
       "Jean Delvare" <khali@linux-fr.org>,
       "Paul Mackerras" <paulus@samba.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
In-Reply-To: <20070409130432.f4902155.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45F7C083.7090504@boichat.ch> <45FE1D44.8000805@boichat.ch>
	 <200703221137.35906.dtor@insightbb.com> <461A455C.9040508@boichat.ch>
	 <20070409130432.f4902155.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 09 Apr 2007 21:53:32 +0800
> Nicolas Boichat <nicolas@boichat.ch> wrote:
>
> > Fixed all these. Thanks.
> >
> > Andrew, could you please push this patch in mm too?
> >
> > Best regards,
> >
> > Nicolas
> >
> > - Invert y axis on input device.
> > - Only activate the input device polling timer when the device is open.
> > - Others minor fixes asked by Dmitry Torokhov.
> >
> > Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
>
> Thanks.
>
> I've been assuming that this patch will go via Jean, since it is in
> drivers/hwmon/applesmc.c.  But perhaps that is inappropriate, and it is
> more a Paul or Dmitry thing.  Or a me thing.
>
> Who wants to take it??

I'd say Jean - he's maintaining drivers/hwmon, isn't he?

-- 
Dmitry
