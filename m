Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZI3MKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZI3MKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZI3MKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:10:43 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:7410 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZI3MKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Rc3Na0Ai8xlp0z/fwhYwszh47wdshXR5gf8/qumbZ6a9x44yn+twmVQ89GoHII11AP
         nyk4V0WyKPd+Rc/GkNy2dKuAzWxjHjLYbMFiOv7RDUHm4/tlbuFCoxL5owiC6kWhaGlC
         K/nDfWf4W5rslEQWlYmQIas9vxQ2Wz6jm0qtE=
MIME-Version: 1.0
In-Reply-To: <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com>
References: <20090930120655.GG1412@ucw.cz> <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 30 Sep 2009 20:10:26 +0800
Message-ID: <f17812d70909300510t106a07b1u3caae9ec4127e26f@mail.gmail.com>
Subject: Re: 2.6.32-rc1: spitz boots but suspend/resume is broken
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       omegamoon@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mmm.... if not due to kernel image size constraints, I'd really like to merge
all the zaurus configs into one.

On Wed, Sep 30, 2009 at 8:09 PM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> On Wed, Sep 30, 2009 at 4:06 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> Hi!
>>
>> matrix keyboard driver needs to be enabled, otherwise it seems ok.
>>
>> Unfortunately, it does not respond to power button in any visible way
>> :-(. Any ideas what might be wrong/how to debug it?
>
> Enable gpio-keyboard driver, verify (or port power button to it :))
> and check that
> enable_wakeup is enabled.
>
> BTW: on tosa initially i had a problem w/ wakeup. The power button wasn't
> able to wake the device up. However there was another gpio that was OR of
>  power button and AC-in gpios that had to be used for wakeup. Please check
> if the same design applies to your device.
>
>>                                                                Pavel
>> --
>> (english) http://www.livejournal.com/~pavelmachek
>> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>>
>
>
>
> --
> With best wishes
> Dmitry
>
