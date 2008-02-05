Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbYBEVZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbYBEVZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbYBEVZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:25:34 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:52468 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbYBEVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=wQp45heFMte0f6O8Kn9y+rq3VFkTMBmR+WnLV+4rdr1giWVA8cqNcML2dQldk2ScLZ1LU+8UcIu+KJ9MxTsbsiuGJAT1LvpYhodLP3+FjyCfewwVWQgPbfYw9TW+lYX+XQkmh9UWFR3mAJZ/0fkeJdzADMmavRVI1MFfDV5Il/0=
Message-ID: <31e679430802051325n52b7b600va6cfcf1f1fdca8b8@mail.gmail.com>
Date: Tue, 5 Feb 2008 16:25:31 -0500
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: T61P sound issue
Cc: tiwai@suse.de, "Andrew Morton" <akpm@linux-foundation.org>,
       "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
	 <20080204194038.d8851b8d.akpm@linux-foundation.org>
	 <20080205113633.GI27738@hjernemadsen.org>
	 <20080205102219.83fe459d.akpm@linux-foundation.org>
	 <31e679430802051304l7c1d68d8r153c753a5b96087a@mail.gmail.com>
	 <Pine.LNX.4.64.0802052207330.30873@twin.jikos.cz>
X-Google-Sender-Auth: 7b28adb15bfd34bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2008 4:16 PM, Jiri Kosina <jikos@jikos.cz> wrote:
> [ added Takashi ]
>
> On Tue, 5 Feb 2008, Felipe Balbi wrote:
>
> > > > > > Could anyone make T61P's ICH8 sound controller to work properly?
> > Good that there's a lot of people using T61p, it's a good machine.
> > I'll upgrade my BIOS and try again the crappy sound.
>
> I have just bought X61s, and it seems to have the very same soundcard as
> your T61p does:
>
> 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
>         Subsystem: Lenovo Lenovo Thinkpad T61
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at fe220000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>         Capabilities: [70] Express Unknown type IRQ 0
>         Capabilities: [100] Virtual Channel
>         Capabilities: [130] Unknown (5)
>
> The sound also doesn't work with 2.6.24 (tried modprobing the
> snd-hda-intel with 'model=thinkpad', didn't make any difference). The
> mixer settings seem to be correct, but there is no sound.
>
> Two strange things in alsamixer:
>
> - it is possible to change volume of the "PCM" toggle, but it is missing
>   the possibility to mute/unmute (the box with "MM"/"OO" simply isn't
>   there)
>
> - the "Headphone" toggle has "OO" as it is unmuted, but there is no
>   possibility to change its volume, the volume box is completely missing
>
> Takashi, if you need any other information which would help resolving
> this, please let me know.

Exactly the same here :-)

>
> Thanks,
>
> --
> Jiri Kosina
>



-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
