Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYAFJ0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYAFJ0F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYAFJZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:25:56 -0500
Received: from koto.vergenet.net ([210.128.90.7]:52161 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYAFJZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:25:54 -0500
Date: Sun, 6 Jan 2008 18:25:48 +0900
From: Simon Horman <horms@verge.net.au>
To: David Miller <davem@davemloft.net>
Cc: apw@us.ibm.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] Fix regression in ip command line processing
Message-ID: <20080106092545.GA3172@verge.net.au>
References: <20071226025903.GB14422@verge.net.au> <20080106035816.GA16459@us.ibm.com> <20080105.232033.240181112.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105.232033.240181112.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 11:20:33PM -0800, David Miller wrote:
> From: Amos Waterland <apw@us.ibm.com>
> Date: Sat, 5 Jan 2008 22:58:16 -0500
> 
> > ADDRESS ASSIGNED
> > 
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=on"
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=dhcp"
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=both"
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=any"
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::on"
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::dhcp"
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=10.0.2.15::10.0.2.2:255.255.255.0::eth0:off"
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=10.0.2.15::10.0.2.2:255.255.255.0::eth0:on"
> > 
> > ADDRESS NOT ASSIGNED
> > 
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip="
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=off"
> > qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::off"
> 
> I really wish Simon had tested his original patch as extensively
> as you have, this is the second major regression it has caused.
> :-/

Ok, this time around its an issue with my understainding of how things
are supposed to work. But sorry none the less.

-- 
Horms

