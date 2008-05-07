Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbYEGOoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbYEGOoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761382AbYEGOn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:43:58 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:43449 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761966AbYEGOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ax2Jpjn/3jac1UJviNxWYbESgMhCFR3CqAotPNEHV5g6wQVTPPVbtqz+Uw1P7T6W9PXBxoaIzmHh+Us4x02+Wg/nzDOhizTQs3AnacuELCRm0oI4hg146mkpY0B7PXdeNyewfKN4z0p1Lgy5n7yZx4NLtqRs/EQDyRHhQwfmrLE=
Message-ID: <c4e36d110805070743m6f47e83al19ec37648dc8043d@mail.gmail.com>
Date: Wed, 7 May 2008 16:43:39 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Andrea Arcangeli" <andrea@qumranet.com>
Subject: Re: Suspend to memory is freezing my machine
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080507143355.GE8362@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
	 <20080507143355.GE8362@duo.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/7 Andrea Arcangeli <andrea@qumranet.com>:
>
> On Sun, May 04, 2008 at 09:37:54AM +0200, Zdenek Kabelac wrote:
>  > Hello
>  >
>  > With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
>  > complete freeze of my T61 during suspend. (dual core, 2GB).
>  >
>  > I'm running kernel with no_console_suspend - but all I can see is
>  > blinking cursor on an empty screen - thus even when I run kernel with
>  > most debug options turned on, I can't pass more details so far.  I run
>  > suspend with with SD card in - so maybe some update in the MMC driver
>  > might be responsible for this ?
>  >
>  > Also - I think that option no_console_suspend doens't work correctly -
>  > as many times with suspend I do not see any log message on my console
>  > screen. However sometimes the log is shown.
>
>  Same here. Suspend to ram crashes on resume starting in 2.6.25 (didn't
>  test 2.6.25-rc in my production system).
>
>  Because this isn't 100% reproducible bisecting may return false
>  negatives.


Of course I've planned to bisect for the lost console logging - maybe tomorrow.

The crash in suspend is pretty random - I've never got the lock at my
will - usually it happens when I completely do not expect it ;)

Zdenek
