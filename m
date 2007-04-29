Return-Path: <linux-kernel-owner+w=401wt.eu-S1030943AbXD2Rnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030943AbXD2Rnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030914AbXD2Rng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:43:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:42648 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbXD2Rkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kjd9bKaa57GjT9wWAyPcGUk/ZJ4Gu+nNuj5ggXT/0n9YYMw+9rbiI+2SzzvP41ktRsg5KDOCJvOXyobD8azfVbz5+gx+bEDcEzKWqSa3j8OejPG9nUqDc1BcxS6tGjkyhOX4bHnFnETdWc6stX9etU6f1erL4TIgEkgfrOJWGrw=
Message-ID: <6bffcb0e0704291040q6dc04683yf2543a0dd578a05f@mail.gmail.com>
Date: Sun, 29 Apr 2007 19:40:37 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Giridhar Pemmasani" <pgiri@yahoo.com>
Subject: Re: Boot failure with 2.6.21 with snd-maestro3
Cc: "Takashi Iwai" <tiwai@suse.de>, alsa-devel@alsa-project.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <944251.71448.qm@web32407.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <944251.71448.qm@web32407.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 29/04/07, Giridhar Pemmasani <pgiri@yahoo.com> wrote:
> When snd-maestro3 (ESS Maestro 3 driver) is enabled, kernel 2.6.21 fails to
> boot - it seems to stop at various points depending on what other modules are
> enabled. Disabling snd-maestro3 fixes all issues. Moreover, with everything
> else being same, using maestro3.c from 2.6.20 kernel and using it in 2.6.21
> kernel also works - i.e., system boots fine. I will try to isolate the issue
> and follow up.

Please revert this patches
http://www.stardust.webpages.pl/files/patches/alsa_revert/
and test kernel after each revert.

Takashi, I'll add this to known regressions for -stable team.

>
> Giri

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
