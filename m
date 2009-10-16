Return-Path: <linux-kernel-owner+w=401wt.eu-S935624AbZJPAua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935624AbZJPAua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762705AbZJPAu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:50:29 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35967 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbZJPAu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YfeC/LQlil3ShOdsSkYZb3PdakGv2xH98V+rh6pE0Q5zEW4X+x8rkhbZ4+71mqludz
         0Wh/1Ooz0zLsypLl6518KoBNmrNH4iK66+E20/ZYZnaRaH2Hf0RFFg/+bUL1E7/DV9/P
         smYCat8chgXkeLqd57rtK+KCQ+Lw8ID3Z45yo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0910151911490.10951@p34.internal.lan>
References: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan> 
	<1255645796-29944-1-git-send-email-bdonlan@gmail.com> <alpine.DEB.2.00.0910151831020.15317@p34.internal.lan> 
	<alpine.DEB.2.00.0910151852510.8329@p34.internal.lan> <alpine.DEB.2.00.0910151855320.3244@p34.internal.lan> 
	<3e8340490910151605j357b303btb26505a2c04cf2d4@mail.gmail.com> 
	<alpine.DEB.2.00.0910151911490.10951@p34.internal.lan>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 15 Oct 2009 20:49:32 -0400
Message-ID: <3e8340490910151749r583d46c0o212e1f4ff7eac955@mail.gmail.com>
Subject: Re: [PATCH] Add quirk for ACPI reboots on Intel DP55KG boards.
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: bruce.w.allan@intel.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 7:30 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Same, all methods fail, :(
>
> Justin.

Was there a message on dmesg about setting the reboot type?
dmesg | grep 'series board detected'

If not, please dump the DMI identification values Linux is using like so:
for i in /sys/class/dmi/id/*; do if [ -f $i ]; then echo -n "$i \"";
cat $i | tr -d '\n'; echo '"'; fi; done
