Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0CKA2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 19:28:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60935 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0CKA2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:28:00 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: howto combat highly pathologic latencies on a server?
Date: Thu, 11 Mar 2010 01:27:52 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <201003101817.42812.hpj@urpla.net> <20100310232940.GB16344@discord.disaster>
In-Reply-To: <20100310232940.GB16344@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003110127.53041.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18LSZp2sNY0vfO/2pfWfeZ8WIOt9fXyrEwH/oc
 av6a+roksrxq2omoHA8sTLR+7BoHsq0rQwwcDV2EdTt+i46WH0
 DVqQkddiCOShhxI7rMyyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010, 00:29:40 Dave Chinner wrote:
> On Wed, Mar 10, 2010 at 06:17:42PM +0100, Hans-Peter Jansen wrote:
> >
> > The xfs filesystems are mounted with rw,noatime,attr2,nobarrier,noquota
> > (yes, I do have a BBU on the areca, and disk write cache is effectively
> > turned off).
>
> Make sure the filesystem has the "lazy-count=1" attribute set (use
> xfs_info to check, xfs_admin to change). That will remove the
> superblock from most transactions and significant reduce latency of
> transactions as they serialise while locking it...

Dave, this modification sounds promising. Will do them during the weekend.
Also Christoph mentioned some pending patches for fdatasync and NFS metadata 
updates in his XFS status report from February, that sounded _really_ 
exciting. 

Happily awaiting these bits in the stable universe ;-)

Thanks,
Pete
