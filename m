Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZBFPhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZBFPhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZBFPhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:37:23 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:33645 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZBFPhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:37:21 -0500
Subject: Re: next-20090206: kernel BUG at mm/slub.c:1132
From: Chris Mason <chris.mason@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-btrfs@vger.kernel.org,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
In-Reply-To: <a4423d670902060710m4919f6d6p1ffae13859c891be@mail.gmail.com>
References: <a4423d670902060710m4919f6d6p1ffae13859c891be@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 10:37:10 -0500
Message-Id: <1233934630.17551.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.498C5929.01CE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 18:10 +0300, Alexander Beregalov wrote:
> Hi
> 
> I run dbench on btrfs, which is on file on xfs
> 
> btrfs: disabling barriers on dev /dev/loop/0
> ------------[ cut here ]------------
> kernel BUG at mm/slub.c:1132!
> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/kernel/uevent_seqnum

Btrfs hammers on slab caches quite a lot, can you reproduce this without
loop or without btrfs?

-chris


