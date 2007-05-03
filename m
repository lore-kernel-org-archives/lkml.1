Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXECJZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXECJZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXECJZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:25:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:54154 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXECJZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QIzVsvNiFnDFlV51Gx14cflLSAqY9yD3xZtEp9TWjAdmY45txouQn7kZ848pB6k1Zpp/KzA4faE59KQ1t3lK7cAVjCVyFRZm3+H3zKha1oyi7+40Xy8gzuOY0OjHb+97yGuV0L/E+5IU0PLO1TpiEbGYIia0mLMqhM4bLx9RHoI=
Message-ID: <f058a9c30705030225s122ffbag54a33aa810996d8f@mail.gmail.com>
Date: Thu, 3 May 2007 10:25:07 +0100
From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
To: "David Greaves" <david@dgreaves.com>
Subject: Re: FEATURE REQUEST: merge MD software raid and LVM in one unique layer.
Cc: david@lang.hm, "Diego Calleja" <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46399876.2030800@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f058a9c30705021214k75da330ai4d79a2b6b2806652@mail.gmail.com>
	 <f058a9c30705021218p4fdb4747kb5b4b9000ad50ef2@mail.gmail.com>
	 <20070502221045.ad20b915.diegocg@gmail.com>
	 <f058a9c30705021351i24c7adc2i4c7e8a76e3b8d1bb@mail.gmail.com>
	 <Pine.LNX.4.64.0705021756210.5342@asgard.lang.hm>
	 <46399876.2030800@dgreaves.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, David Greaves <david@dgreaves.com> wrote:
> david@lang.hm wrote:
> > On Wed, 2 May 2007, Miguel Sousa Filipe wrote:
> >
> >> On 5/2/07, Diego Calleja <diegocg@gmail.com> wrote:
> >>>  El Wed, 2 May 2007 20:18:55 +0100, "Miguel Sousa Filipe"
> >>>  <miguel.filipe@gmail.com> escribió:
> >>>
> >>> >  I find it high irritanting having two kernel interfaces and two
> >>> >  userland tools that provide the same funcionality, which one should I
> >>> >  use?
> >>>
> >>>  I doubt users care about kernel's design; however the lack of
> >>> unification of  userspace tools is a real problem. Just my 2¢.
>
> >> This is also a problem for any developer who tries to improve
> >> usability in this area by creating some unified userland tools to
> >> manipulate MD & LVM. (Imagining myself implementing some userland tool
> >> to create some "storage devices" + mount points.. doesn't  seem easy
> >> nor fun..).
> >
> > why do you care if the userspace tool that does the resizing makes
> > system calls to one layer or to two layers? how would you know?
>
> Indeed!!
>
> EVMS
>
> http://evms.sourceforge.net/
>
> Enterprise Volume Management System
>
> In order to make the transition to EVMS as smooth as possible, EVMS includes
> compatibility with a number of existing storage and volume management systems.
> Currently, EVMS recognizes:
>
>     * All locally attached disks
>     * DOS-style disk partitions (used extensively on Linux systems)
>     * GPT disk partitions (mainly used on IA-64)
>     * S/390 disk partitions (CDL/LDL)
>     * BSD disk partitions
>     * Macintosh disk partitions
>     * Linux MD/Software-RAID devices
>     * Linux LVM volume groups and logical volumes (versions 1 and 2)
>
> Anything else?
>
> Oh... yes:
>
> In addition to providing compatibility with these existing systems, EVMS also
> provides new functionality that can be built on top of any of the above
> "volumes" that EVMS already recognizes. Features that are currently included are:
>
>     * Bad Block Relocation
>     * Linear Drive Linking
>     * Generic Snapshotting
>
> Enough? or would you like:
> In addition to these volume-level features, the EVMS tools provide convenient
> integration with numerous filesystem tools, to allow tasks such as mkfs and fsck
> directly from the EVMS user interfaces. Currently, the following filesystems are
> supported:
>
>     * Ext2/3
>     * JFS
>     * ReiserFS
>     * XFS
>     * Swap
>     * OCFS2
>     * NTFS
>     * FAT
>
> ??
> Oh, and for the l33t there's a GUI and screenshots...
>
> Of course, in keeping with ZFS, this management layer is all proprietary and
> costs megabucks - or is it GPL, can never remember...
>
> Damn that "irritanting" architecture - keeps us from doing cool things...
>
> Seriously - I hope this is useful ;)
>
> David
>

That was indeed informative, thank you for your reply.
I'll try EVMS sometime soon then.. :D

-- 
Miguel Sousa Filipe
