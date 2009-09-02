Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZIBTWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZIBTWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZIBTWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:22:45 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:42205 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbZIBTWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fLKENdcE5RQLjn/BxcwA8meZSejF/605znijOYj2A9CtXZrk+vdoehgrWmxR4CysFk
         qyInHXY37PjUYOwMOLsq6jmZRXb4N2GqiVPP0S4JZokJsvEaz24ZfCrQc8PTZHPU6WbA
         gw8pm7rx4tut6EjZk0u8tO1cX/MY6GTWcS9bI=
MIME-Version: 1.0
In-Reply-To: <1251789947.3483.215.camel@rzhang-dt>
References: <1251789947.3483.215.camel@rzhang-dt>
Date: Wed, 2 Sep 2009 20:22:45 +0100
Message-ID: <9b2b86520909021222k6cc49456vc3232e488eef9e37@mail.gmail.com>
Subject: Re: [PATCH V6 1/2] introduce ALS sysfs class
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/09, Zhang Rui <rui.zhang@intel.com> wrote:
>
> Introduce ALS sysfs class.
>
> ALS sysfs class provides a standard sysfs interface for
> Ambient Light Sensor devices.
>
> please read Documentation/ABI/testing/sysfs-class-als for
> detailed sysfs designs.
>
> ﻿CC: Pavel Machek <pavel@ucw.cz>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---

> +++ linux-2.6/drivers/als/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# Ambient Light Sensor sysfs device configuration
> +#
> +
> +menuconfig ALS
> +	tristate "Ambient Light Sensor sysfs device"
> +	help
> +	  This framework provides a generic sysfs interface for
> +	  Ambient Light Sensor devices.
> +	  If you want this support, you should say Y or M here.

Gratuitous nitpick:
Can this option be made non-visible (or hidden behind CONFIG_EMBEDDED)?

Maybe you copied the pattern of the thermal sysfs interface - but the
ACPI thermal driver is useful to keep your computer cool even without
the sysfs interface.  ALS drivers are useless without the sysfs
interface, no?

Regards
Alan
