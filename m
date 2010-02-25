Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab0BYBDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:03:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31326 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab0BYBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:03:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=YoTuS8tIVJc+EVKo8cZxKgomhwfuGt/IcgFrHs4FupMUDivRhg0eYJy/lMvZLM89e
	mt4GQKNxjBLgZdOnA+Xcg==
Date: Thu, 25 Feb 2010 01:03:14 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Americo Wang <xiyou.wangcong@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
In-Reply-To: <2375c9f91002211730l6835cae1x1693da3d94fccc0c@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1002250051380.4394@sister.anvils>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>  <ClJsQB_ZlxO.A.YyG.4dagLB@chimera> <2375c9f91002211730l6835cae1x1693da3d94fccc0c@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1347328712-1267059808=:4394"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1347328712-1267059808=:4394
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 22 Feb 2010, Am=C3=A9rico Wang wrote:
> On Mon, Feb 22, 2010 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a summary re=
port
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.32. =C2=A0Please verify if it still should be listed and let t=
he tracking team
> > know (either way).
> >
> >
> > Bug-Entry =C2=A0 =C2=A0 =C2=A0 : http://bugzilla.kernel.org/show_bug.cg=
i?id=3D15202
> > Subject =C2=A0 =C2=A0 =C2=A0 =C2=A0 : lockdep warning during elevator_s=
witch
> > Submitter =C2=A0 =C2=A0 =C2=A0 : Hugh Dickins <hugh.dickins@tiscali.co.=
uk>
> > Date =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: 2010-01-31 23:55 (22 da=
ys old)
> > References =C2=A0 =C2=A0 =C2=A0: http://marc.info/?l=3Dlinux-kernel&m=
=3D126498212613051&w=3D4
> >
>=20
> This should be fixed by:
> http://lkml.org/lkml/2010/2/11/329

This regression does still need to be listed for 2.6.33-rc8-git.

Americo is right that the warning goes away if I apply those patches from E=
ric,
but they look like more than we'd be adding into 2.6.33 at this stage ...
and bootup of latest git plus those patches gave me 71 messages of the form
BUG: key fxxxxxxx not in .data!

Hugh
--8323584-1347328712-1267059808=:4394--
