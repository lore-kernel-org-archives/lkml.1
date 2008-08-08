Return-Path: <linux-kernel-owner+w=401wt.eu-S1764451AbYHHXPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764451AbYHHXPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760440AbYHHXPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:15:21 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34784 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759870AbYHHXPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:15:19 -0400
Date: Fri, 8 Aug 2008 19:13:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Grant Coady <gcoady.lk@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
In-Reply-To: <m3sktfw1v5.fsf@maximus.localdomain>
Message-ID: <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain> <20080808172629.232bed01@lxorguk.ukuu.org.uk> <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com> <m3sktfw1v5.fsf@maximus.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-856349815-1218237211=:3254"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-856349815-1218237211=:3254
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 9 Aug 2008, Krzysztof Halasa wrote:

> Grant Coady <grant_lkml@dodo.com.au> writes:
>
> >   =C2=A6 =C2=A6    --- Serial ATA (SATA) and Parallel ATA (PATA) driver=
s            =C2=A6 =C2=A6
> >   =C2=A6 =C2=A6    <*>   AHCI SATA support                             =
             =C2=A6 =C2=A6
> >   =C2=A6 =C2=A6    [*]   ATA ACPI Support                              =
             =C2=A6 =C2=A6
> >   =C2=A6 =C2=A6    [ ]   SATA Port Multiplier support                  =
             =C2=A6 =C2=A6
> >   =C2=A6 =C2=A6    < >   Silicon Image 3124/3132 SATA support          =
             =C2=A6 =C2=A6
> >   =C2=A6 =C2=A6    [*]   ATA SFF support                               =
             =C2=A6 =C2=A6
> >   =C2=A6 =C2=A6            *** Serial ATA drivers ***                  =
             =C2=A6 =C2=A6
> >   =C2=A6 =C2=A6    < >     Initio 162x SATA support                    =
             =C2=A6 =C2=A6
> >   =C2=A6 =C2=A6    < >     Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA suppo=
rt           =C2=A6 =C2=A6
>
> As noted, it's both PATA and SATA. People searching for PATA-only
> PIIX support may have trouble locating it under SATA.
>
> Why not remove ATA SFF support visual option (or leave it for
> optional off-tree drivers only, if it makes sense) and SELECT it
> when any driver using it is selected? I'm not sure that users know
> they need SFF, or what's that.
>
> I think I would also ask for PATA and for SATA first:
>
> [*] PATA support
> [*] SATA support

  that was sort my original thought, but i don't know enough about ATA
fundamentals to know if it makes sense for these to be independently
selectable.  that's why i nobly bailed and left it for someone else to
do the actual work.  :-)

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-856349815-1218237211=:3254--
