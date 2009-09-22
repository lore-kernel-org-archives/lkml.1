Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZIVPx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZIVPx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbZIVPx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:53:26 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46385 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbZIVPxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:53:25 -0400
Date: Tue, 22 Sep 2009 11:51:32 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] blackfin: Cleanup linker script using new linker script
 	macros.
In-Reply-To: <8bd0f97a0909220846h338291fbwf1290d7a55443bbb@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0909221149040.15595@dr-wily.mit.edu>
References: <1252292753-11792-1-git-send-email-tabbott@ksplice.com>  <8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com>  <alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu> <20090916202655.GA17153@merkur.ravnborg.org> 
 <8bd0f97a0909161337v6edbe204wfd83b4c3118b3a27@mail.gmail.com>  <alpine.DEB.1.10.0909221035180.15595@dr-wily.mit.edu> <8bd0f97a0909220830w7435ee32h3ec8f667e2b46d79@mail.gmail.com>  <alpine.DEB.1.10.0909221133380.15595@dr-wily.mit.edu>
 <8bd0f97a0909220846h338291fbwf1290d7a55443bbb@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1257051904-1546915671-1253634692=:15595"
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1257051904-1546915671-1253634692=:15595
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 22 Sep 2009, Mike Frysinger wrote:

> On Tue, Sep 22, 2009 at 11:39, Tim Abbott wrote:
> > So are you going to send this to Linus? =C2=A0I'd be happy to do so, bu=
t I'd
> > need your ack.
>=20
> if you apply the .text_l1 update (.init.ramfs -> .exit.data), then you
> can add my s-o-b.  otherwise the original patch as posted is broken.

Right, I modified the patch in my git tree when you first mentioned it=20
like so:

-=09.text_l1 L1_CODE_START : AT(LOADADDR(.init.ramfs) + SIZEOF(.init.ramfs)=
)
+=09.text_l1 L1_CODE_START : AT(LOADADDR(.exit.data) + SIZEOF(.exit.data))

=09-Tim Abbott
---1257051904-1546915671-1253634692=:15595--
