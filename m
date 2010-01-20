Return-Path: <linux-kernel-owner+w=401wt.eu-S1751711Ab0ATPtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab0ATPtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457Ab0ATPtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:49:16 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:38281 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0ATPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:49:15 -0500
Date: Wed, 20 Jan 2010 07:48:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 19 (vhost_net)
Message-Id: <20100120074815.ceff3a44.randy.dunlap@oracle.com>
In-Reply-To: <20100120113341.GA9610@redhat.com>
References: <20100119181041.ab55f645.sfr@canb.auug.org.au>
	<20100119104139.2ec9164b.randy.dunlap@oracle.com>
	<20100120113341.GA9610@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B5725E4.0161:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 13:33:41 +0200 Michael S. Tsirkin wrote:

> On Tue, Jan 19, 2010 at 10:41:39AM -0800, Randy Dunlap wrote:
> > On Tue, 19 Jan 2010 18:10:41 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20100118:
> > 
> > 
> > When CONFIG_TUN is not enabled:
> > 
> > drivers/built-in.o: In function `get_socket':
> > net.c:(.text+0x2899a3): undefined reference to `tun_get_socket'
> > 
> > 
> > so VHOST_NET can either depend on TUN or select TUN, but if it
> > selects TUN, it will also need to select CRC32.
> > 
> > ---
> > ~Randy
> 
> Just to clarify sure, the broken configuration is VHOST=y TUN=m, I sent
> a fixup patch to forbid that configuration.  But both VHOST=y TUN=n and
> VHOST=m TUN=n build fine for me on linux-next (commit
> af2b07e7e0a9c6bf82ce4d6a77f0412ae54f575b).  Randy, could you please
> confirm that VHOST=y TUN=m is what you tested, or alternatively make
> your .config available to me so I can reproduce the problem?

Hi Michael,

You are correct, VHOST_NET=y, TUN=m.

Thanks.
---
~Randy
