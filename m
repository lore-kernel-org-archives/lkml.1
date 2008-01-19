Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbYASWR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbYASWR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYASWRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:17:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:31070 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYASWRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AnekTwCw3KsMc1tc+bamQm15Co3TcYh4NkJ/A1uns21RhNoXNfAVkprBOv3h4jbsGItit6b0vgOs6bleXqT6ONgnyTujiouqUbXBcQgc/6V4setkpKSs2WhVGmzplAY/Yvm6qvnS7c1dsQoK6gYs1alfSBcBmEGWQLNsi1aAk5Y=
Message-ID: <6101e8c40801191417k7906422chf657895152b61a2d@mail.gmail.com>
Date: Sat, 19 Jan 2008 23:17:14 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: konqueror deadlocks on 2.6.22
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <200801192357.13774.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200801192114.41427.a1426z@gawab.com>
	 <6101e8c40801191053j7e81988fm8aaf0a75fb8bd405@mail.gmail.com>
	 <200801192357.13774.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add cc (ingo)

and then please update to CFS-v24.1
http://people.redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.6.22.15-v24.1.patch
--------------------

On 1/19/08, Al Boldi <a1426z@gawab.com> wrote:
> Oliver Pinter (Pintér Olivér) wrote:
> > This kernel is vanilla 2.6.22.y or with CFS?
>
> Yes with CFSv20.4, as in the log.
>
> It also hangs on 2.6.23.13
>
> > On 1/19/08, Al Boldi <a1426z@gawab.com> wrote:
> > > I was just attacked by some deadlock issue involving sqlite3 and
> > > konqueror. While sqlite3 continues to slowly fill a 7M-record db in
> > > transaction mode, konqueror hangs for a few minutes, then continues only
> > > to hang again and again.
> > >
> > > Looks like an fs/blockIO issue involving fsync.
> > >
> > > As a workaround, is there a way to make fsync soft?
>
>
> Thanks!
>
> --
> Al
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
