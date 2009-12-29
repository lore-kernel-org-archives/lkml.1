Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZL2Izv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZL2Izv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 03:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZL2Izv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 03:55:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43014 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZL2Izu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 03:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=txoz1l5j8nC/dUrVfjhYULnhUP1RptWlO0r+ahfanNY2n/FQTi1nQb871VCl8QvOeq
         pf7kLNBYwj/RoIFJduSF2YsuFOq3kTyizo6ClHBX+emqd3SzQe530AAdDD0cKVETM7av
         EjNzJvgj5c4NNGiwLvVReduZgjBzc7y83oCDY=
To: "Luke-Jr" <luke@dashjr.org>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe \(Nokia-D\/Helsinki\)" <felipe.balbi@nokia.com>
Subject: Re: [PATCH] OMAP2: add USB platform data and initialization for Nokia N800 and N810
References: <200912290152.16357.luke@dashjr.org>
	<87d41yxjx9.fsf@purkki.valot.fi> <200912290246.57663.luke@dashjr.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 29 Dec 2009 10:55:46 +0200
In-Reply-To: <200912290246.57663.luke@dashjr.org> (Luke-Jr's message of "Tue\, 29 Dec 2009 02\:46\:50 -0600")
Message-ID: <873a2uxip9.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luke-Jr" <luke@dashjr.org> writes:

> On Tuesday 29 December 2009 02:29:22 am Kalle Valo wrote:
>> "Luke-Jr" <luke@dashjr.org> writes:
>> > Tested on Nokia N810 in Linux-OMAP tree. Mainline is not bootable yet.
>> 
>> What's the problem in mainline? I haven't tested n8x0 for months :(
>
> Lack of platform support, as far as I know. Until we have cbus,
> there's no way to get the LCD powered...

Oh that. I have only used serial console with mainline. Luckily Felipe
did some cbus patches, I haven't checked them yet though.

>> I think a separate file is not needed, it's not that much code. I
>> recommend to just adding it directly to board-n8x0.c. It's simple and
>> easier for everyone.
>
> Seemed simpler to manage in a separate file

Having lots of small files is difficult IMHO.

> though not as necessary as the LCD stuff (which I also have a patch
> against mainline for, but it needs tahvo...)

Nice.

>> CONFIG_MACH_NOKIA_N8X0_LCD does not look right here.
>
> Heh, looks like my isolate-and-merge-to-mainline got messed up there.
> Of course it should be CONFIG_MACH_NOKIA_N8X0_USB :)

Yeah, maybe eating too much ham caused it ;)

> Also, scripts/checkpatch.pl gave me a warning about the extern in a .c file, 
> but I couldn't figure out where else it could reasonably go. Any ideas? :/

Yes, just put everything into one file :) No need for externs then.

-- 
Kalle Valo
