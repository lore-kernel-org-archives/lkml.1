Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbYBVV7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbYBVV7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYBVV7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:59:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:57857 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYBVV7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xjvRgbEUBZD1Wt6QjtuSMocyZfkKxDNj0aXYvVy5yEjR+bvIgUn0HJohsSOCMbQPNb1FeraPL2IsSoqjJnIsLrp7ewILMHYbuA8fmDZjMigZkfdfx7/lctG9/vlqgvYvPneG/0rYp4JKLAD2ObgmhiP966dNYdM/Fy6GK6gFeD4=
Message-ID: <6101e8c40802221359o464df7cbi708317f695615a0a@mail.gmail.com>
Date: Fri, 22 Feb 2008 22:59:03 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 00/23] 2.6.22-stable review
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20080222213927.GA8686@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080222213927.GA8686@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for the new rc/release!

Oliver Pinter

On 2/22/08, Greg KH <gregkh@suse.de> wrote:
> This is the start of the stable review cycle for the 2.6.22.19 release.
> There are 23 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
> These patches are sent out with a number of different people on the
> Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> to add your name to the list.  If you want to be off the reviewer list,
> also email us.
>
> Responses should be made by Monday, Feb 24, 2008, 22:00:00 UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.22.19-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -----------
>  Makefile                                        |    2
>  arch/i386/kernel/entry.S                        |    2
>  arch/i386/kernel/ptrace.c                       |   22 +++--
>  arch/i386/kernel/traps.c                        |   10 +-
>  arch/x86_64/kernel/ptrace.c                     |   23 ++++--
>  drivers/ata/sata_promise.c                      |   91
> ++++++++++++++++++++++--
>  drivers/block/cciss.c                           |    6 +
>  drivers/char/agp/intel-agp.c                    |   17 +++-
>  drivers/char/ipmi/ipmi_si_intf.c                |    3
>  drivers/media/video/usbvision/usbvision-cards.c |    1
>  drivers/misc/sony-laptop.c                      |   15 ++-
>  drivers/mtd/nand/cafe_nand.c                    |    3
>  drivers/net/via-velocity.c                      |   16 ++--
>  drivers/pci/hotplug/fakephp.c                   |   39 +++++++++-
>  drivers/scsi/sd.c                               |   34 ++++----
>  fs/nfs/client.c                                 |   35 +++++----
>  fs/nfs/dir.c                                    |   11 +-
>  fs/nfs/getroot.c                                |    3
>  fs/nfs/inode.c                                  |    4 -
>  fs/nfs/write.c                                  |   20 ++++-
>  fs/nfsd/nfs2acl.c                               |    2
>  fs/nfsd/nfs3acl.c                               |    2
>  fs/nfsd/nfs4xdr.c                               |    5 -
>  include/linux/quicklist.h                       |    8 --
>  mm/memory.c                                     |    2
>  mm/quicklist.c                                  |   12 ++-
>  net/netfilter/nf_conntrack_proto_tcp.c          |   33 ++++++--
>  27 files changed, 306 insertions(+), 115 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
