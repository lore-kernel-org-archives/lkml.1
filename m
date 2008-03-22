Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYCVWKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYCVWKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYCVWKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:10:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:10906 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYCVWKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ee3Xd/KdKxA8o7e5xJaqPkSVk1HMoAQHvYjATFAUUInDmwyV88iHFIyrK2ZWsHBJaG4kicoe6V42ja996OGZGBpW4eIic4oNAg/XBdcddtpb268MYN7IBmIwF5H5jmF3HUSbnfaDGYBuWO9GKOKtLRsQPgY8kIdUolu7kPWfV+k=
Message-ID: <1ba2fa240803221510n8d5800ft32e0ffa179542aba@mail.gmail.com>
Date: Sun, 23 Mar 2008 00:10:19 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: SDIO: IO-Ready Bit
Cc: lkml <linux-kernel@vger.kernel.org>, benzizbit@gmail.com
In-Reply-To: <20080318192018.1815fd57@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ba2fa240803180400y1d7a2740t2c21b8b73a755016@mail.gmail.com>
	 <20080318123325.0843b854@mjolnir.drzeus.cx>
	 <1ba2fa240803181043v511df0b6tbe43174feb2f7537@mail.gmail.com>
	 <20080318192018.1815fd57@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 8:20 PM, Pierre Ossman <drzeus@drzeus.cx> wrote:
> On Tue, 18 Mar 2008 19:43:40 +0200
>
> "Tomas Winkler" <tomasw@gmail.com> wrote:
>
>
> > On Tue, Mar 18, 2008 at 1:33 PM, Pierre Ossman <drzeus@drzeus.cx> wrote:
>  > >
>
> > >  A better approach is to simply have the drivers for your subfunctions synchronize things. Make sure noone calls sdio_enable_func() until the firmware has been loaded.
>  >
>  > This could even be done from user space in case you want to use a
>  > standard driver.
>  >
>  > Won't this prevent us from compiling the drivers into kernel?
>  > Second how this possible especially with standard driver as they are
>  > loaded. I know you can enforce module loading but how can you enforce
>  > probing order form user space?
>
>  You can tell the kernel to not automatically attach drivers to devices.
>  That way you can have a user space process control exactly the order
>  and timing of things. I haven't played around with this feature myself
>  though, so I can't really provide you with any good information on how
>  to use it. You should be able to google up something useful.

I couldn't find anything that can prevent the probe function to be
called in case the module is already loaded. I've looked at udev and
HAL and no much I found.
I will dig into kernel sources, maybe finding out how can be bus
enumeration triggered again or something like this.
Any pointers will be appreciated.

Thanks
Tomas
