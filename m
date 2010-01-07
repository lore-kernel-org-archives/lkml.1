Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839Ab0AGJ2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0AGJ2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460Ab0AGJ2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:28:19 -0500
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:38002 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab0AGJ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:28:16 -0500
From: Marvin <marvin24@gmx.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: vfs related crash in 2.6.33-rc2
Date: Thu, 7 Jan 2010 10:27:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc2-00268-g45d28b0-dirty; KDE/4.3.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
References: <200912301733.19077.marvin24@gmx.de> <20100106154123.b12547f3.akpm@linux-foundation.org> <1262822158.4251.179.camel@localhost>
In-Reply-To: <1262822158.4251.179.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001071027.58865.marvin24@gmx.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marvin24@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> On Wed, 2010-01-06 at 15:41 -0800, Andrew Morton wrote:
> > On Thu, 31 Dec 2009 05:59:32 +0900
> >
> > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> > > Marvin <marvin24@gmx.de> writes:
> > > >> Marvin <marvin24@gmx.de> writes:
> > > >> > Hi,
> > > >> >
> > > >> > I'm getting a lot of these:
> > > >> >
> > > >> > kernel: general protection fault: 0000 [#1] SMP
> > > >> > kernel: last sysfs file:
> > > >> > /sys/devices/pci0000:00/0000:00:18.3/modalias kernel: CPU 0
> > > >> > kernel: Pid: 12177, comm: packagekitd Not tainted 2.6.33-rc2 #1
> > > >> > ...
> > > >> >
> > > >> > filesystem is ext4 (in case it matters).
> > > >>
> > > >> BTW, are you using nfs client on this machine?
> > > >
> > > > um - yes, now that I think about it... I killed a nfs umount process
> > > > (because of an offline server) shortly before the oopses started to
> > > > fire.
> > >
> > > OK. Probably, this oops would be same with one which happened on my
> > > machine recently. That path in patch corrupts dcache hash, so it can be
> > > the cause of strange behavior or oops on dcache hash.
> > >
> > > If so, the attached patch would fix it.
> > >
> > > Thanks.
> >
> > Guys, what's the status of this fix?  Did Marvin have a chance to test
> > it?  Are the NFS developers aware of it?
> >
> > Thanks.
> 
> Sorry for the delay. The above fix looks correct to me, but I too would
> like a confirmation that it fixes the Oops before I push it to Linus.
> 
> In the meantime, I've committed it to my linux-next branch.

It seems that I send the reply to Hirofumi only, sorry for that. The patch works fine 
- no oops anymore.

Thanks

Marvin
