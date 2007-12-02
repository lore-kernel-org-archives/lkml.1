Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbXLBNz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbXLBNz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXLBNzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:55:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33830 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752952AbXLBNzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:55:15 -0500
Date: Sun, 2 Dec 2007 13:51:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: namespace support requires network modules to say "GPL"
Message-ID: <20071202135104.006c5a15@the-village.bc.nu>
In-Reply-To: <20071201163035.321fd554@freepuppy.rosehill>
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca>
	<20071201111736.297dd99a@freepuppy.rosehill>
	<20071201163035.321fd554@freepuppy.rosehill>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 16:30:35 -0800
Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> On Sat, 1 Dec 2007 11:17:36 -0800
> Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> 
> > Then init_net needs to be not GPL limited. Sorry, we need to allow
> > non GPL network drivers.  There is a fine line between keeping the
> > binary seething masses from accessing random kernel functions, and allowing
> > reasonable (but still non GPL) things like ndiswrapper to use network
> > device interface.
> > 
> I spoke too soon earlier, ndiswrapper builds and loads against current
> 2.6.24-rc3. Vmware and proprietary VPN software probably do not. Once again I don't
> give a damn, but the enterprise distro vendors certainly care.

Enterprise distro vendors ship kernels from the 2.6.19 era, so I don't
see why they care.

Alan
