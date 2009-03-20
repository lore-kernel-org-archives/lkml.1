Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZCTOQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZCTOQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZCTOQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:16:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:43412 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZCTOQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:16:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=evwh9VJ63+JN426T4/0GwE0ucYUJmBJyhiR2wSmPHSN3PXveySvxNcrTPhFOmPFDnx
         GpBlhrvwlwj78+2iy2bY+7XBxQzAhg/zU8nwyb/sL1YNpQddeSjnvScjxmO68HZSodZK
         HQwnPMVd8XjyIuF0uF6b/LRkKaYpe8T6MwODQ=
MIME-Version: 1.0
In-Reply-To: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
References: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
Date: Fri, 20 Mar 2009 15:15:59 +0100
Message-ID: <74d0deb30903200715v7de33289mcbd49cb44f629b46@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] GPIO switch framework
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       juha.yrjola@solidboot.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 20, 2009 at 2:50 PM, Jani Nikula
<ext-jani.1.nikula@nokia.com> wrote:
>
> Hi -
>
> This RFC patchset is a pretty straightforward adaptation of OMAP GPIO
> switch framework for mainline integration.
>
> The GPIO switch framework allows reporting and changing GPIO switches
> via sysfs, with debouncing and sysfs/in-kernel notifications for input
> switches.

Doesn't this partially duplicate what the input layer is for?
There is also a gpio-keys driver in input/keyboard already that can
report switch events (EV_SW) to the input layer, but it doesn't have
the in-kernel notification.

> The switches are added as /sys/class/gpio/switch-<switch name> under
> the gpiolib sysfs structure.
>
> BR,
> Jani.
>
>
> Jani Nikula (3):
>      GPIOLIB: Add new gpio_device_create function
>      GPIO-SWITCH: Adaptation of GPIO switch framework for mainline
>      GPIO-SWITCH: Kconfig and Makefile
>
>  drivers/gpio/Kconfig        |   10 +
>  drivers/gpio/Makefile       |    2 +
>  drivers/gpio/gpio-switch.c  |  534 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/gpio/gpiolib.c      |   52 +++++
>  include/asm-generic/gpio.h  |   12 +
>  include/linux/gpio-switch.h |   74 ++++++
>  6 files changed, 684 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/gpio-switch.c
>  create mode 100644 include/linux/gpio-switch.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

regards
Philipp
