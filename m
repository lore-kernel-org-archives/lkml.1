Return-Path: <linux-kernel-owner+w=401wt.eu-S935617AbZJOXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935617AbZJOXGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935492AbZJOXGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:06:25 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:50050 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbZJOXGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E2X/mQ/V0EO2oelgFKLzBCLZRfJ95LSkeQ7wu7f533J2Ha+YYcWUnWERsbK/iRXJJ6
         kiGm9RZbfOdCYa+0bJH4hHm+lTxgtAdiehAKGCdk6xCv55ff74/WVqLc1Frd2A79RB43
         AoMkmrcPqMFk5sLUE35L0lP2L46DhKXQUovJ4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0910151855320.3244@p34.internal.lan>
References: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan> 
	<1255645796-29944-1-git-send-email-bdonlan@gmail.com> <alpine.DEB.2.00.0910151831020.15317@p34.internal.lan> 
	<alpine.DEB.2.00.0910151852510.8329@p34.internal.lan> <alpine.DEB.2.00.0910151855320.3244@p34.internal.lan>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 15 Oct 2009 19:05:27 -0400
Message-ID: <3e8340490910151605j357b303btb26505a2c04cf2d4@mail.gmail.com>
Subject: Re: [PATCH] Add quirk for ACPI reboots on Intel DP55KG boards.
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: bruce.w.allan@intel.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 6:59 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Still no match (and still hangs at reboot)...
>
> # cat /usr/src/linux-2.6.31.3/arch/x86/kernel/reboot.c|grep -i intel
>        {       /* Handle problems with rebooting on Intel DP55KG */
>                .ident = "Intel DP55KG",
>                        DMI_MATCH(DMI_SYS_VENDOR, "Intel Corp."),
>
> Justin.
>

Sorry - bear with me a bit here, it's my first time writing quirks for this :)
Try:
            DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
            DMI_MATCH(DMI_BOARD_NAME, "DP55KG"),
