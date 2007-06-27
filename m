Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbXF0NJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbXF0NJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbXF0NJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:09:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:23068 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbXF0NJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LQ+p8ofq+f0aizf00ga0GQ3W3J6+E1VZe/RynMxbi4ns2GZymC91wIX06M1WrLJgk+8agqN3VKz+JRP23P2pgUhmIHB1Z1KNbDDrHNi+XkoZ95rbwTvw1vUESTaNUHRAFh3boJ3J2AbTMgR5S/QGiZojuQ/YY+xBVmY3J2Rw82w=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jan Kandziora <jjj@gmx.de>
Subject: Re: Limiting load of certain processes
Date: Wed, 27 Jun 2007 16:06:48 +0300
User-Agent: KMail/1.9.4
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706211950.40825.jjj@gmx.de> <200706260444.35818.maximlevitsky@gmail.com> <200706261148.32478.jjj@gmx.de>
In-Reply-To: <200706261148.32478.jjj@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271606.48773.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 12:48, Jan Kandziora wrote:
> Am Dienstag, 26. Juni 2007 03:44 schrieb Maxim Levitsky:
> > Hi.
> >
> > Try  to set $_hogthreshold = (1) in dosemu.conf
> >
> > This helps a lot for me.
>
> This "nice"s the dosemu process -- I already use this setting. However, if
> no other process is runnable, dosemu will get again all CPU power, which
> disturbs power-saving. Thanks for sharing ideas, anyway.
>
> Kind regards
>
> 	Jan


Hi,

Well, I almost sure that this is not true, 
or maybe you are not using dosemu 1.4.0, and other one behaves differently.

Anyway, if I run dosemu 1.4.0 with that setting and stock freedos
command.com the cpu usage is well below 5%, and dosemu task is not reniced
There are even times that I forget that dosemu is running.

Also I don't know why but dosemu 1.4.0 has new sound system that is way better 
that 1.2 one, but it is not enabled so you need to set $_sound=(2) to get it,
what is nice is that this one uses SDL ( read alsa) for output, and has OPL3  
emulation, so MIDI plays out of box

Regards,
	Maxim Levitsky
