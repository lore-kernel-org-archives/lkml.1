Return-Path: <linux-kernel-owner+w=401wt.eu-S1761911AbYDYKKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911AbYDYKKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759825AbYDYKKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:10:11 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:61296 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664AbYDYKKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ePVri2fpxXZes5rifOCkNlRLoz5Y/IFRrBml7hrZXxS7Tbmbwj1L1ZuaJI4iF5eQcv9AMy1i0c+YuQysSo/FcD2JGhBQ86STBvf+pZwOfXYrX8vixjB9Y1vs/iNBRHnVPGQHygvS9JzXDD4PCv9AnoLnFpKxNZLRasUpZvJ8b1A=
Message-ID: <386072610804250309j5f2222cfj2f58b3b92d091a3a@mail.gmail.com>
Date: Fri, 25 Apr 2008 18:09:52 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/1] Input/Joystick Driver: add support AD7142 joystick driver (v2)
Cc: khali@linux-fr.org, andre@bitwigglers.org, linux-input@vger.kernel.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org, vapier.adi@gmail.com,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <20080418131149.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206643110-8789-1-git-send-email-cooloney@kernel.org>
	 <20080418131149.ZZRA012@mailhub.coreip.homeip.net>
X-Google-Sender-Auth: 6d7d08b859e9992f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 1:15 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Bryan,
>
>
>  On Thu, Mar 27, 2008 at 11:38:30AM -0700, Bryan Wu wrote:
>  > +     input->keybit[BIT_WORD(BTN_BASE)] = BIT_MASK(BTN_BASE) |
>  > +                                             BIT_MASK(BTN_BASE2) |
>  > +                                             BIT_MASK(BTN_BASE3) |
>  > +                                             BIT_MASK(BTN_BASE4);
>  > +     input->keybit[BIT_WORD(KEY_UP)] |=  BIT_MASK(KEY_UP) |
>  > +                                             BIT_MASK(KEY_DOWN) |
>  > +                                             BIT_MASK(KEY_LEFT) |
>  > +                                             BIT_MASK(KEY_RIGHT);
>  > +
>
>  Why don't you use REL_X/REL_Y to report directional movement? Using
>  buttons for that is pretty unusual.
>

In our development board, it includes UP/DOWN/LEFT/RIGHT 4 buttons. So
this driver matches this.
Please found some information about the hardware as below:
http://docs.blackfin.uclinux.org/doku.php?id=capacitance_touch_sensors&s[]=ad7142

Thanks
-Bryan
