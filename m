Return-Path: <linux-kernel-owner+w=401wt.eu-S1751126AbZL0SbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbZL0SbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 13:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZL0SbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 13:31:04 -0500
Received: from kroah.org ([198.145.64.141]:57668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZL0SbB (ORCPT <rfc822;Linux-Kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 13:31:01 -0500
Date: Sun, 27 Dec 2009 10:30:50 -0800
From: Greg KH <greg@kroah.com>
To: JD <jd1008@gmail.com>
Cc: Linux Kernel List <Linux-Kernel@vger.kernel.org>
Subject: Re: RT2860 driver
Message-ID: <20091227183050.GA12428@kroah.com>
References: <4B343611.6070206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B343611.6070206@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 07:48:33PM -0800, JD wrote:
> I have built and booted several kernel.org releases of
> kernel 2.6, ever since rt2860 was added to the staging area.
> I have an rt2860 mini-pci wifi card.
> To make a long story short, the last kernel release I built
> with rt2860 config enabled (module), that actually worked
> (i.e. rt2860 driver worked) was (I think) kernel 2.6.28.
>
> I have not been able to get it working in 2.6.[29,30,31,32]
>
> So, what I have been doing is to copy full rt2860 directory
> (which I had extracted and saved from the last working version)
> into the latest kernel, and I make sure that
>
> rt2860/config.mk has
>
> HAS_WPA_SUPPLICANT=y
>
> HAS_NATIVE_WPA_SUPPLICANT_SUPPORT=y
>
> This is the only way I can get my wireless working.
>
> So, if anyone on this list has it working in latest kernel,
> without resorting to what I am doing, please share you "how-to".

Can you try using 'git bisect' to determine the exact change that caused
your device to stop working?

thanks,

greg k-h
