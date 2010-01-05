Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141Ab0AEBCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0AEBCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 20:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042Ab0AEBCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 20:02:12 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:47317 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab0AEBCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 20:02:10 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2010 20:02:10 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nj8NGuIOoZFlCcrSX73LseUECYBpqdHjejkS6978jJyFA/Hhsh7+DwmFvmIcxWTK9g
         T8oHSyCtHoK5cYVTkMDZA3VOBCvaYc9YdypdQUDHBx+KTXN2tzvYtJHu2OO/a3Q7yy3G
         +2UBjts/h1DUu0wBgpDLMO7KYJ7FS+bM0Tzl4=
MIME-Version: 1.0
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 Jan 2010 16:55:42 -0800
Message-ID: <43e72e891001041655r261dd087yfcd50883c618185b@mail.gmail.com>
Subject: Re: [Stable-review] [00/97] 2.6.32.3 stable review
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 4:31 PM, Greg KH <gregkh@suse.de> wrote:
> This is the start of the stable review cycle for the 2.6.32.3 release.
> There are 97 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
> Responses should be made by Thursday, Jan 7, 00:00:00 UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.3-rc1.gz
> and the diffstat can be found below.
>
>
> thanks,

Wireless stuff looks good, except I'd prefer if we'd get the EEPROM
fix for ath5k merged in there as well but I realize a respective
upstream sha1sum is not yet available, but say we get it before
Friday, is it OK to queue it in? The patch in question is:

http://marc.info/?l=linux-wireless&m=126261964315049&w=2

Don't spot yet any other important fixes missing.

  Luis
