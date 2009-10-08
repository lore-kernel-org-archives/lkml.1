Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZJHGRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZJHGRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZJHGRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:17:20 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:4312 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZJHGRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X1BQHRYtQYGKzV4mWeTlGb+K/j8ppDE8cLC3Rf8KnXid3KI24XU3CfBXQrFofLIjiX
         jFzhbh7V4WltDpXM+xTEBe49ssK6i44aJ6e12XXhSgaOUkHQ2L5sp6M3bSMjEfP9XjRj
         Y0MfQzc9RzDdzjAcDjgglkP+bXpZ8v/1vY7XI=
MIME-Version: 1.0
In-Reply-To: <20091002224124.GY1133@earth.li>
References: <65168.192.168.10.89.1253788033.squirrel@dbdmail.itg.ti.com>
	 <20091002224124.GY1133@earth.li>
Date: Thu, 8 Oct 2009 11:46:12 +0530
Message-ID: <d6a0f7aa0910072316y622f8a7ch40624dc43d1a650b@mail.gmail.com>
Subject: Re: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
From: Govindraj <govindraj.ti@gmail.com>
To: Jonathan McDowell <noodles@earth.li>
Cc: "Govindraj.R" <govindraj.raja@ti.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 4:11 AM, Jonathan McDowell <noodles@earth.li> wrote:
> On Thu, Sep 24, 2009 at 03:57:13PM +0530, Govindraj.R wrote:
>> From: Govindraj R <govindraj.raja@ti.com>
>>
>> This patch adds support for OMAP3430-HIGH SPEED UART Controller.
>>
>> Signed-off-by:        Govindraj R <govindraj.raja@ti.com>
>> Reviewed-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> Reviewed-by: Tony Lindgren <tony@atomide.com>
>> ---
>
>> +config SERIAL_OMAP
>> +     bool "OMAP serial port support"
>> +     depends on ARM && ARCH_OMAP
>> +     select SERIAL_CORE
>> +     help
>> +     If you have a machine based on an Texas Instruments OMAP CPU you
>> +     can enable its onboard serial ports by enabling this option.
>
> If it's OMAP3 hardware then should the "depends on" be ARCH_OMAP3 ||
> ARCH_OMAP4, rather than allowing it for OMAP1 + 2 as well?
>
> J.
>

Agree. Will do the changes.


> --
> Revd. Jonathan McDowell, ULC | If they can't take a joke....fuck 'em.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
---
Regards,
Govindraj.R
