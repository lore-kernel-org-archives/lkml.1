Return-Path: <linux-kernel-owner+w=401wt.eu-S933997AbZDIO2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbZDIO2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760525AbZDIO2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:28:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:38858 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050AbZDIO2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:28:36 -0400
Cc: Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       linux-next <linux-next@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       sachinp <sachinp@linux.vnet.ibm.com>, linux-net@vger.kernel.org,
       Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Message-Id: <21BA9149-6948-42C0-9F76-033185BB5296@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: subrata@linux.vnet.ibm.com
In-Reply-To: <1239285022.5188.63.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [BUILD FAILURE 01] Next April 9 : PPC64 randconfig [drivers/net/fs_enet/fs_enet-main.c]
Date: Thu, 9 Apr 2009 09:28:13 -0500
References: <1239285022.5188.63.camel@subratamodak.linux.ibm.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9, 2009, at 8:50 AM, Subrata Modak wrote:

> Observed the following build error:
>
> drivers/net/fs_enet/fs_enet-main.c: In function ‘fs_enet_probe’:
> drivers/net/fs_enet/fs_enet-main.c:1096: error: ‘struct net_device’  
> has
> no member named ‘open’
> drivers/net/fs_enet/fs_enet-main.c:1097: error: ‘struct net_device’  
> has
> no member named ‘hard_start_xmit’
> drivers/net/fs_enet/fs_enet-main.c:1098: error: ‘struct net_device’  
> has
> no member named ‘tx_timeout’
> drivers/net/fs_enet/fs_enet-main.c:1100: error: ‘struct net_device’  
> has
> no member named ‘stop’
> drivers/net/fs_enet/fs_enet-main.c:1101: error: ‘struct net_device’  
> has
> no member named ‘get_stats’
> drivers/net/fs_enet/fs_enet-main.c:1102: error: ‘struct net_device’  
> has
> no member named ‘set_multicast_list’
> drivers/net/fs_enet/fs_enet-main.c:1111: error: ‘struct net_device’  
> has
> no member named ‘do_ioctl’
> make[3]: *** [drivers/net/fs_enet/fs_enet-main.o] Error 1
> make[2]: *** [drivers/net/fs_enet] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
>
> Regards--
> Subrata
>
> <randconfig1-ppc64-next20090409.txt>

This is because CONFIG_COMPAT_NET_DEV_OPS isnt set and needs to be for  
this driver to build.  I've asked the netdev guys about either fixing  
the driver or adding the proper thing to Kconfig to select  
CONFIG_COMPAT_NET_DEV_OPS.

- k