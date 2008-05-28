Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbYE1AB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbYE1AB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 20:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbYE1ABu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 20:01:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:27788 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbYE1ABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 20:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iqTLdhWOFeov6tHoHVraVd5EeUUEXGMXTEX74aeOVuJM++j3pkVZyaFrMQQWTKmzN1Hbe5mFdwJTXJ5OAE+ONbjOYqZKZMNKYX11s5WEKWiv0EdRnZSb8qEu6A+kpykfhzCQRXBHE6AVJXz1HXgX7jpsrLc5O4dlKM6zum6LxAE=
Message-ID: <31e679430805271701h73ee1eb2p80329900008827f8@mail.gmail.com>
Date: Wed, 28 May 2008 03:01:47 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: HAVE_CLK (for <linux/clk.h> support)
Cc: "Felipe Balbi" <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805271614.55233.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805231044.59969.david-b@pacbell.net>
	 <1211879340-22013-1-git-send-email-felipe.balbi@nokia.com>
	 <200805271614.55233.david-b@pacbell.net>
X-Google-Sender-Auth: 3142ff50b1964277
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 28, 2008 at 2:14 AM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 27 May 2008, Felipe Balbi wrote:
>> This patch adds support for MUSB and TUSB controllers
>> integrated into omap2430 and davinci. It also adds support
>> for external tusb6010 controller.
>
> The most significant issue I know of with this patch [0] is actually
> an arch issue.  On ones like x86, with no support for the clock API,
> this driver will build but not link:
>
> ERROR: "clk_enable" [drivers/usb/musb/musb_hdrc.ko] undefined!
> ERROR: "clk_disable" [drivers/usb/musb/musb_hdrc.ko] undefined!
> ERROR: "clk_put" [drivers/usb/musb/musb_hdrc.ko] undefined!
> ERROR: "clk_get" [drivers/usb/musb/musb_hdrc.ko] undefined!
>
> I don't know of any other drivers with this particular issue,
> but nonetheless ... I think the following is an appropriate
> resolution.
>
> Comments from anyone else?

I actually like it. I didn't see this error cuz I was only building
musb for arm architecture.

But why only davinci and omap?
What about: mach-aaec2000, mach-at91, mach-ep93xx, mach-integrator,
mach-lh7a40x, mach-ns9xxx, mach-pnx4008, mach-pxa, mach-realview,
mach-sa1100, mach-versatile, mach-s3c24x.


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
