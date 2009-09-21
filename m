Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbZIUSIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbZIUSIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZIUSIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:08:15 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:54341 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZIUSIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bNURz1kLGCP5MPq6GnrxnGMwA1p9O7ub0YLl9r7LgzO4nMBUzJb589x/Lqu96mWI3/
         mfuTBWLTdTDJ5re4XUMZcnQAM7wkuVW9bkk152LDvbnNQ7+kc/57ZWyG2LBEBmFh9dmY
         r3dzcBO0F+FZk34c0Hzwsp0qKF1ZLv4yAg+K4=
MIME-Version: 1.0
In-Reply-To: <f17812d70909211008j62967af7qdf3456be722a9e13@mail.gmail.com>
References: <1253215662-11404-1-git-send-email-getarunks@gmail.com> 
	<f17812d70909180210xdceaf22u7901befa23cd89c7@mail.gmail.com> 
	<771cded00909210049g6c7c8075pe4ca331184e39415@mail.gmail.com> 
	<dfeb90390909211003h3b16e984q1fdf94450bdb39@mail.gmail.com> 
	<f17812d70909211008j62967af7qdf3456be722a9e13@mail.gmail.com>
From: Arun KS <getarunks@gmail.com>
Date: Mon, 21 Sep 2009 11:07:58 -0700
Message-ID: <dfeb90390909211107m1c61f8a9h5606059b6aabb7ee@mail.gmail.com>
Subject: Re: [PATCH] Adding LED1 & LED2 control for DA9034 backlight driver
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org,
       rpurdie@rpsys.net, eric.miao@marvell.com, mike@compulab.co.il
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:08 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
>
> > Apparently there is a bug in the hardware design on my custom board. We are
> > using LED1 for backlight control.
> > Thanks Haojian for clarification.
> >
>
> Now you know that :-)
>
> Either let your hardware engineer change the design, or there are still
> workarounds, you can control the LED1/2 through the sysfs entries.

If I apply the patch which I send, backlight driver is working well
through the da093x_bl.c driver.
Because LED1 driver is same as the WLED driver apart from current
level it can provide. WLED can provide max of 32mA but LED can only
provide current <500uA.

Thanks for your concern.

Arun

>
> - eric
