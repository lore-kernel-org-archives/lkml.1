Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZLEPHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZLEPHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 10:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbZLEPHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 10:07:11 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60851 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbZLEPHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 10:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CpMzGw1QnCGjoQkMhpsh/jWjFkFu4qrr9lkb0ecBa3Vldw2AUA/pybQJa+8wcX/+su
         Fzsvxu1F0ZY+AmPQh86V+T9OBIiQlqRRVAOYyLpWEZe0bKQD3rq+Ob9XStidV7HvyKTf
         J2iGWUSBOAuQ4GdtwmfKEfNvxWlfliviDLHKc=
MIME-Version: 1.0
In-Reply-To: <s5haaxxh3pf.wl%tiwai@suse.de>
References: <c1f41c620912042148n7d3f6f29h713a2d44369a5810@mail.gmail.com>
	 <s5haaxxh3pf.wl%tiwai@suse.de>
Date: Sat, 5 Dec 2009 22:07:16 +0700
Message-ID: <c1f41c620912050707u4f701385h1a6a299cc4d85c8@mail.gmail.com>
Subject: Re: 2.6.31 -> 2.6.32 Sound and video regressions
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 5, 2009 at 9:53 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Sat, 5 Dec 2009 12:48:57 +0700,
> Emmanuel Benisty wrote:
>>
>> Sound
>> The "Front" mixer channel has disappeared. I'm left with no sound and
>> no way to enable it.
>> alsa-info.sh output is attached.
>
> Try to unmute "Speaker" mixer switch.

Thanks Takashi, actually it seems to be a kernel config problem: I
just tried the stock .32 kernel of the distribution I'm using and all
channels are there again. I just have to figure out what has changed
that requires my config to be modified.
