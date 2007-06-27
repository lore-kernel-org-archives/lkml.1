Return-Path: <linux-kernel-owner+w=401wt.eu-S1762370AbXF0REY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762370AbXF0REY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbXF0REP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:04:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48967 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbXF0REN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:04:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UdWr0klyn3zt8X/Go7BAE/YFwQrrPMsOZ8QbLCBshBq2ZrdzMSZQcGS8hH91Rwgm8sEIdatafopWWtIzhNsuQWOzBOfMx7g2Q7PwLNw2uFhsVpCZYMYFxSp2R3N5YGfekE4Og6aCP5k5xk9ZG4jfj5jwadsD8/cjCSmUlhEBvYs=
Message-ID: <d120d5000706271004u5e2304dekd4ad5315cdd4a55@mail.gmail.com>
Date: Wed, 27 Jun 2007 13:04:13 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Clemens Koller" <clemens.koller@anagramm.de>
Subject: Re: 2.6.21.5: BUG: usbtouchscreen.c DMC TSC-10 wrong descriptor type / type->init() failed.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <468294E4.40801@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <468294E4.40801@anagramm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/27/07, Clemens Koller <clemens.koller@anagramm.de> wrote:
> drivers/usb/input/usbtouchscreen.c: usbtouch_probe - type->init() failed, err: -19

dmc_tsc10_init() returns -ENODEV (-19) when device responds with
something other than 0x06 0x00 to the "reset" and "set rate" commands.
It would be interesting to see what your touchscreen responses are.

-- 
Dmitry
