Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYGAJNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYGAJNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYGAJN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:13:26 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45017 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbYGAJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:13:24 -0400
Message-Id: <6B16FAEFB450496A9AA95BFF27BD6AE6@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Alasdair G Kergon" <agk@redhat.com>
Cc: <akpm@linux-foundation.org>, <viro@ZenIV.linux.org.uk>, <axboe@kernel.dk>,
       <mtk.manpages@googlemail.com>, <linux-kernel@vger.kernel.org>,
       <xfs@oss.sgi.com>, <dm-devel@redhat.com>,
       <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
References: <20080630212005t-sato@mail.jp.nec.com> <20080630135433.GA22522@agk.fab.redhat.com>
In-Reply-To: <20080630135433.GA22522@agk.fab.redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] freeze feature ver 1.8
Date: Tue, 1 Jul 2008 18:12:32 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16480
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alasdair G Kergon wrote:
>> Currently, ext3 in mainline Linux doesn't have the freeze feature which
>> suspends write requests.  So, we cannot take a backup which keeps
>> the filesystem's consistency with the storage device's features
>> (snapshot and replication) while it is mounted.
>> In many case, a commercial filesystem (e.g. VxFS) has
>> the freeze feature and it would be used to get the consistent backup.
>> If Linux's standard filesytem ext3 has the freeze feature, we can do it
>> without a commercial filesystem.
>
> Is the following a fair summary?

Yes, you are right.
We'd like to use the freeze feature without device-mapper/LVM.

> 1. Some filesystems have a freeze/thaw feature.  XFS exports this to
> userspace directly through a couple of ioctls, but other filesystems
> don't.  For filesystems on device-mapper block devices it is exported to
> userspace through the DM_DEV_SUSPEND ioctl which LVM uses.
>
> 2. There is a desire to access this feature from userspace on non-XFS
> filesystems without having to use device-mapper/LVM.
>
> Alasdair

Cheers, Takashi 
