Return-Path: <linux-kernel-owner+w=401wt.eu-S934154AbXHFTSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbXHFTSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934044AbXHFTS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:18:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:3510 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038AbXHFTS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VJvaCEIhp4NZdgDe7GErxMZ0M+kszdlTTDii5V2Nupg/D/bPzkHMJjd288ka9pRfACpXWypOwURSmsY7FngvjPg1OHjZN4ckpvjYN9ANh/vxxRdptBRZYwLDiIXXCza5ZdaV9+FMI7+/CybBfWrdaSkNm5EerENJZJWrW4ChKSE=
Message-ID: <92cbf19b0708061218k456af713g1a7ee0a8864e5995@mail.gmail.com>
Date: Mon, 6 Aug 2007 12:18:26 -0700
From: "Chakri n" <chakriin5@gmail.com>
To: "=?ISO-8859-1?Q?Malte_Schr=F6der?=" <maltesch@gmx.de>
Subject: Re: OOPS in shrink_dcache_for_umount
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <92cbf19b0708050939r6164474di64949e4044691951@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <92cbf19b0708021427l7c88c642g3901e393ac2b90b9@mail.gmail.com>
	 <20070804120105.47ae82fc@highlander.home.lan>
	 <92cbf19b0708050939r6164474di64949e4044691951@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patches do not help. The system still paniced in the same place.

Still trying to correlate the problem & fix to specific patch.

Regards
--Chakri

On 8/5/07, Chakri n <chakriin5@gmail.com> wrote:
> Hi Malte,
>
> Thanks for the information.
>
> Based on your suggestion I tried the following two patches on top of
> 2.6.18-1.8.el5 NFS code. I had to keep the changes minimum to fix this
> crash in our release.
>
> http://linux-nfs.org/Linux-2.6.x/2.6.20-rc7/linux-2.6.20-007-fix_readdir_negative_dentry.dif
> http://linux-nfs.org/Linux-2.6.x/2.6.20-rc7/linux-2.6.20-008-fix_readdir_positive_dentry.dif
>
> The systems are running for the past 7 hours with out any issues.
> Hopefully this fixes it.
>
> Regards
> --Chakri
>
> On 8/4/07, Malte Schröder <maltesch@gmx.de> wrote:
> > On Thu, 2 Aug 2007 14:27:04 -0700
> > "Chakri n" <chakriin5@gmail.com> wrote:
> >
> > > Hi,
> > >
> > > We are seeing this problem while unmounting file systems. It happens
> > > once in a while.
> > > I am able to grab the trace and core from linux-2.6.18-1.8.el5, but I
> > > have observed the same problem with linux-2.6.20.1 kernel.
> > >
> > > Has this problem fixed in recent kernel?
> > >
> >
> > I had those too ... but I haven't seen one in a while.
> > I currently run 2.6.22 + cfs-v19 + the Patch from
> > http://linux-nfs.org/Linux-2.6.x/2.6.22/linux-2.6.22-NFS_ALL.dif
> >
> > --
> > ---------------------------------------
> > Malte Schröder
> > MalteSch@gmx.de
> > ICQ# 68121508
> > ---------------------------------------
> >
> >
> >
>
