Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYJVSvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYJVSvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYJVSvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:51:05 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59336 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYJVSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wESAokNbL00pfFpZtVCKxYE+jFiTupdQGk68cZ/4XRRPqgqpDwITSawMQnU8zro9if
         kzabiqu0WDmpA84daIqHxL1S3F6I9zexrqJlptfGbe+sNhuw2RHX5lVwxFzqP9+gBEh0
         ghQ8VU7Bo1Dpzb8V1d4HpY+qpB7aQWRK0Q3kM=
Message-ID: <d9def9db0810221150s1552a0daq8e0c58a85eb20399@mail.gmail.com>
Date: Wed, 22 Oct 2008 20:50:59 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alex Riesen" <fork0@users.sourceforge.net>
Subject: Re: [PATCH] em28xx patches against the latest git tree
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de
In-Reply-To: <20081022184058.GB4626@blimp.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com>
	 <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
	 <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com>
	 <d9def9db0810221110g6f104b17g36a74704d43c5693@mail.gmail.com>
	 <20081022182924.GA4626@blimp.localdomain>
	 <20081022184058.GB4626@blimp.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 8:40 PM, Alex Riesen
<fork0@users.sourceforge.net> wrote:
> Alex Riesen, Wed, Oct 22, 2008 20:29:24 +0200:
>> Markus Rechberger, Wed, Oct 22, 2008 20:10:49 +0200:
>> > On Wed, Oct 22, 2008 at 7:59 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
>> > > 2008/10/22 Markus Rechberger <mrechberger@gmail.com>:
>> > >>> commit history is available at:
>> > >> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
>> > >>
>> > The [old] driver has a long and rather bad history, which I'd like to avoid
>> > by using the different directory.
>>
>> You could submit patches depricating it. Does the old driver support
>> something yours does not?
>>
>
> BTW, you forgot to a patch to include your driver into Kconfig of
> drivers/media/video. Something like this, perhaps:
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 47102c2..1bbee59 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -781,7 +781,7 @@ source "drivers/media/video/gspca/Kconfig"
>
>  source "drivers/media/video/pvrusb2/Kconfig"
>
> -source "drivers/media/video/em28xx/Kconfig"
> +source "drivers/media/video/empia/Kconfig"
>
>  source "drivers/media/video/usbvision/Kconfig"
>
>

this one slipped through thanks :-)

Markus
