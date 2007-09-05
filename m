Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbXIELf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbXIELf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 07:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXIELft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 07:35:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:19782 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbXIELfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 07:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NVb5POC8MqQKAPGZhBAY9Ffa3zf8dyY1n3T0fuBLEhzMtYr0MDHi4XCkqlQwKUG45/gcdTtKqfrGNcdTXVips6612/pBLXfNDhJplq1GVfBrJciqS9ZSsfZXjoO3lXlDq6Nya/qvDQ+za/kze22qZqGojHp4+MA4sPIh2Z9tgw0=
Message-ID: <ab40e9c0709050435y69cf04d6kfebf0e29faecb09d@mail.gmail.com>
Date: Wed, 5 Sep 2007 13:35:46 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Uli Luckas" <u.luckas@road.de>
Subject: Re: ramdisk
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>
In-Reply-To: <ab40e9c0709050422s413df8c9v4a4fcf6c2437d6b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0709030604u5fecf34dr945ece01b95e622d@mail.gmail.com>
	 <Pine.LNX.4.61.0709041101290.7968@chaos.analogic.com>
	 <200709051007.41085.u.luckas@road.de>
	 <ab40e9c0709050422s413df8c9v4a4fcf6c2437d6b4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

then is there any new hint about that?
I didn't do the memory patition , would this cause the problem?

2007/9/5, Xu Yang <risingsunxy@googlemail.com>:
> Hi Uli,
>
> yes, it is my mistake. actually in the boot option line It was
> root=/dev/ram0 . sorry for the misleading.
>
> regards,
>
> yang
>
>
> 2007/9/5, Uli Luckas <u.luckas@road.de>:
> > On Tuesday, 4. September 2007, linux-os (Dick Johnson) wrote:
> > > On Mon, 3 Sep 2007, Xu Yang wrote:
> > > > Hi everyone,
> > > >
> > > > I want to use ramdisk to boot my filesystem, as I can't use NFS and
> > > > harddisk.
> > > >
> > > > I have load the ramdisk into the ram memory (start address :0x4000000)
> > > >
> > > > and in the boot options I specified : root =dev/ram0 initrd=0x4000000
> > >
> > > Since you don't know what the default directory is, perhaps
> > > root should be /dev/ram0. Also, make sure you actually create
> > > those device nodes in /dev
> > >
> > Hey Dick,
> > where exactly (on which file system) is Xu supposed to create the device
> > nodes? ;-)
> > Xu's problem is, he can't mount his _root_ filesystem in the first place.
> > Therefore I doubt it'd help to have some device nodes somewhere ...
> >
> > Xu,
> > all answers to your posting commented on your kernel command line. The command
> > line you quoted contains "root =dev/ram0".
> > You probably meant to write "root=/dev/ram0". To not waste our time, please
> > clarify if this was a typo before asking further questions.
> >
> > regards,
> > Uli
> >
> > --
> >
> > ------- ROAD ...the handyPC Company - - -  ) ) )
> >
> > Uli Luckas
> > Software Development
> >
> > ROAD GmbH
> > Bennigsenstr. 14 | 12159 Berlin | Germany
> > fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
> > url: www.road.de
> >
> > Amtsgericht Charlottenburg: HRB 96688 B
> > Managing directors: Hans-Peter Constien, Hubertus von Streit
> >
>
