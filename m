Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbZCaEeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbZCaEeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZCaEeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:34:00 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57874 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZCaEd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:33:59 -0400
Message-ID: <49D19D35.7020407@oss.ntt.co.jp>
Date: Tue, 31 Mar 2009 13:33:57 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zq?= =?ISO-8859-1?Q?uez_Cao?= 
	<flvazquez@uvigo.es>,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
References: <200903291928.14451.bzolnier@gmail.com> <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu> <49D03AE1.8070009@redhat.com> <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es> <20090330142518.GI13356@mit.edu>
In-Reply-To: <20090330142518.GI13356@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, Mar 30, 2009 at 10:01:16PM +0900, Fernando Luis Vázquez Cao wrote:
>> Chris, I have just sent patches that attempt to fix both ext3 and
>> ext4 while also adding a per-device sysfs knob tu disable
>> write-flushes. A previous version of this patch set added a new
>> generic mount option but comments from Christoph and others
>> convinced me to turn it into a per-device tunable. Could you take
>> a look at the patches?
> 
> Fernando, see my comments on those patches.  We don't need to issue a
> barrier after a call to sync_inode() or ext[34]_force_commit(), since
> those functions will issue a barrier for us.  It would probably be a
> good idea to use blktrace to test and make sure that we have one and
> exactly one barrier op issued for each fsync().

I'll give blktrace a spin and check if things are working as expected.

Thanks!

- Fernando
