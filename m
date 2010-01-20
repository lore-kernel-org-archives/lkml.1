Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588Ab0ATLgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab0ATLgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 06:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143Ab0ATLgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 06:36:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0ATLgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 06:36:51 -0500
Date: Wed, 20 Jan 2010 13:33:41 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 19 (vhost_net)
Message-ID: <20100120113341.GA9610@redhat.com>
References: <20100119181041.ab55f645.sfr@canb.auug.org.au> <20100119104139.2ec9164b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119104139.2ec9164b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 10:41:39AM -0800, Randy Dunlap wrote:
> On Tue, 19 Jan 2010 18:10:41 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100118:
> 
> 
> When CONFIG_TUN is not enabled:
> 
> drivers/built-in.o: In function `get_socket':
> net.c:(.text+0x2899a3): undefined reference to `tun_get_socket'
> 
> 
> so VHOST_NET can either depend on TUN or select TUN, but if it
> selects TUN, it will also need to select CRC32.
> 
> ---
> ~Randy

Just to clarify sure, the broken configuration is VHOST=y TUN=m, I sent
a fixup patch to forbid that configuration.  But both VHOST=y TUN=n and
VHOST=m TUN=n build fine for me on linux-next (commit
af2b07e7e0a9c6bf82ce4d6a77f0412ae54f575b).  Randy, could you please
confirm that VHOST=y TUN=m is what you tested, or alternatively make
your .config available to me so I can reproduce the problem?

Thanks!

-- 
MST
