Return-Path: <linux-kernel-owner+w=401wt.eu-S965425AbXDGGsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbXDGGsz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 02:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXDGGsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 02:48:54 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54903 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965388AbXDGGsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 02:48:53 -0400
To: ericvh@gmail.com
CC: hpa@zytor.com, jengelh@linux01.gwdg.de, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
In-reply-to: <a4e6962a0704062040q12c0013ek9591b9fbb27caa12@mail.gmail.com>
	(ericvh@gmail.com)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <4616D4D4.6020405@zytor.com>
	 <Pine.LNX.4.61.0704070153180.22181@yvahk01.tjqt.qr>
	 <4616E459.1090409@zytor.com> <a4e6962a0704062040q12c0013ek9591b9fbb27caa12@mail.gmail.com>
Message-Id: <E1Ha4ii-0004sY-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 07 Apr 2007 08:48:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 4/6/07, H. Peter Anvin <hpa@zytor.com> wrote:
> > Jan Engelhardt wrote:
> > > On Apr 6 2007 16:16, H. Peter Anvin wrote:
> > >>>> - users can use bind mounts without having to pre-configure them in
> > >>>> /etc/fstab
> > >>>>
> > >> This is by far the biggest concern I see.  I think the security implication of
> > >> allowing anyone to do bind mounts are poorly understood.
> > >
> > > $ whoami
> > > miklos
> > > $ mount --bind / ~/down_under
> > >
> > > later that day:
> > > # userdel -r miklos
> > >
> >
> > Consider backups, for example.
> >
> 
> This is the reason why enforcing private namespaces for user mounts
> makes sense.  I think it catches many of these corner cases.

Yes, disabling user bind mounts in the global namespace makes sense.

Enabling user fuse mounts in the global namespace still works though,
even if a little cludgy.  All these nasty corner cases have been
thought through and validated by a lot of users.

Thanks,
Miklos
