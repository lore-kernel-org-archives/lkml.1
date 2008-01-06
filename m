Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYAFHUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYAFHUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 02:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYAFHUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 02:20:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44693
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbYAFHUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 02:20:34 -0500
Date: Sat, 05 Jan 2008 23:20:33 -0800 (PST)
Message-Id: <20080105.232033.240181112.davem@davemloft.net>
To: apw@us.ibm.com
Cc: horms@verge.net.au, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] Fix regression in ip command line processing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080106035816.GA16459@us.ibm.com>
References: <20071226025903.GB14422@verge.net.au>
	<20080106035816.GA16459@us.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amos Waterland <apw@us.ibm.com>
Date: Sat, 5 Jan 2008 22:58:16 -0500

> ADDRESS ASSIGNED
> 
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=on"
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=dhcp"
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=both"
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=any"
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::on"
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::dhcp"
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=10.0.2.15::10.0.2.2:255.255.255.0::eth0:off"
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=10.0.2.15::10.0.2.2:255.255.255.0::eth0:on"
> 
> ADDRESS NOT ASSIGNED
> 
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip="
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=off"
> qemu -kernel x86/arch/i386/boot/bzImage /dev/zero -append "ip=::::::off"

I really wish Simon had tested his original patch as extensively
as you have, this is the second major regression it has caused.
:-/

I'll apply your fix, although I'll break up some super long lines
you've added, thanks a lot.
