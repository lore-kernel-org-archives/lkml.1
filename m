Return-Path: <linux-kernel-owner+w=401wt.eu-S1761259AbXF0TKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbXF0TKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbXF0TJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:09:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030AbXF0TJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:09:27 -0400
From: Jan Kandziora <jjj@gmx.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Limiting load of certain processes
Date: Wed, 27 Jun 2007 21:09:16 +0200
User-Agent: KMail/1.9.5
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706211950.40825.jjj@gmx.de> <200706261148.32478.jjj@gmx.de> <200706271606.48773.maximlevitsky@gmail.com>
In-Reply-To: <200706271606.48773.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272109.17472.jjj@gmx.de>
X-Provags-ID: V01U2FsdGVkX19lm82cfv4JwgEG/2RwIhU+eNos4VIvNz4Me9B
 emJ8Mcz2TdLcycIsng4JGpi23jZKgWk9qXzW28y20GmvvqKnrr
 QqB2eDQeZLrHe/kGfQy0w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 27. Juni 2007 15:06 schrieb Maxim Levitsky:
>
> Well, I almost sure that this is not true,
> or maybe you are not using dosemu 1.4.0, and other one behaves differently.
>
> Anyway, if I run dosemu 1.4.0 with that setting and stock freedos
> command.com the cpu usage is well below 5%, and dosemu task is not reniced
> There are even times that I forget that dosemu is running.
>
It's like I wrote in the top post. The problem is not command.com or some 
other freedos application, but an old, proprietary clipper DB application, 
which, in a lot of situations, doesn't behave nice but loops while waiting 
for user interaction.

I tested with dosemu 1.4.0 btw. With dosemu 1.2.x, clipper apps aren't even 
working.


> Also I don't know why but dosemu 1.4.0 has new sound system that is way
> better that 1.2 one, but it is not enabled so you need to set $_sound=(2)
> to get it, what is nice is that this one uses SDL ( read alsa) for output,
> and has OPL3 emulation, so MIDI plays out of box
>
Nice, but out of my focus...

Kind regards

	Jan
