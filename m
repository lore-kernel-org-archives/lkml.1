Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXECIia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXECIia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbXECIia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:38:30 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:33349 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbXECIi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:38:28 -0400
X-Greylist: delayed 1804 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 04:38:27 EDT
Message-ID: <46399876.2030800@dgreaves.com>
Date: Thu, 03 May 2007 09:08:22 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Cc: david@lang.hm, Diego Calleja <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FEATURE REQUEST: merge MD software raid and LVM in one unique
 layer.
References: <f058a9c30705021214k75da330ai4d79a2b6b2806652@mail.gmail.com>  <f058a9c30705021218p4fdb4747kb5b4b9000ad50ef2@mail.gmail.com>  <20070502221045.ad20b915.diegocg@gmail.com> <f058a9c30705021351i24c7adc2i4c7e8a76e3b8d1bb@mail.gmail.com> <Pine.LNX.4.64.0705021756210.5342@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0705021756210.5342@asgard.lang.hm>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Wed, 2 May 2007, Miguel Sousa Filipe wrote:
> 
>> On 5/2/07, Diego Calleja <diegocg@gmail.com> wrote:
>>>  El Wed, 2 May 2007 20:18:55 +0100, "Miguel Sousa Filipe"
>>>  <miguel.filipe@gmail.com> escribió:
>>>
>>> >  I find it high irritanting having two kernel interfaces and two
>>> >  userland tools that provide the same funcionality, which one should I
>>> >  use?
>>>
>>>  I doubt users care about kernel's design; however the lack of
>>> unification of  userspace tools is a real problem. Just my 2¢.

>> This is also a problem for any developer who tries to improve
>> usability in this area by creating some unified userland tools to
>> manipulate MD & LVM. (Imagining myself implementing some userland tool
>> to create some "storage devices" + mount points.. doesn't  seem easy
>> nor fun..).
> 
> why do you care if the userspace tool that does the resizing makes
> system calls to one layer or to two layers? how would you know?

Indeed!!

EVMS

http://evms.sourceforge.net/

Enterprise Volume Management System

In order to make the transition to EVMS as smooth as possible, EVMS includes
compatibility with a number of existing storage and volume management systems.
Currently, EVMS recognizes:

    * All locally attached disks
    * DOS-style disk partitions (used extensively on Linux systems)
    * GPT disk partitions (mainly used on IA-64)
    * S/390 disk partitions (CDL/LDL)
    * BSD disk partitions
    * Macintosh disk partitions
    * Linux MD/Software-RAID devices
    * Linux LVM volume groups and logical volumes (versions 1 and 2)

Anything else?

Oh... yes:

In addition to providing compatibility with these existing systems, EVMS also
provides new functionality that can be built on top of any of the above
"volumes" that EVMS already recognizes. Features that are currently included are:

    * Bad Block Relocation
    * Linear Drive Linking
    * Generic Snapshotting

Enough? or would you like:
In addition to these volume-level features, the EVMS tools provide convenient
integration with numerous filesystem tools, to allow tasks such as mkfs and fsck
directly from the EVMS user interfaces. Currently, the following filesystems are
supported:

    * Ext2/3
    * JFS
    * ReiserFS
    * XFS
    * Swap
    * OCFS2
    * NTFS
    * FAT

??
Oh, and for the l33t there's a GUI and screenshots...

Of course, in keeping with ZFS, this management layer is all proprietary and
costs megabucks - or is it GPL, can never remember...

Damn that "irritanting" architecture - keeps us from doing cool things...

Seriously - I hope this is useful ;)

David
