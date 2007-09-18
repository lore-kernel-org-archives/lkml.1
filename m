Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbXIRD45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbXIRD45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 23:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXIRD4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 23:56:49 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:44241 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbXIRD4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 23:56:49 -0400
Date: Mon, 17 Sep 2007 20:56:25 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: Fwd: Intel DQ35JOE Mainboard 82566DM-2 Gigabit Network
In-reply-to: <b0fbeec40709171830p79dafb72k4bfe40678dc3d740@mail.gmail.com>
To: John Duthie <beyondgeek@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46EF4C69.6070900@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
References: <b0fbeec40709171808i1cccc5fak11498476618d1abf@mail.gmail.com>
 <b0fbeec40709171830p79dafb72k4bfe40678dc3d740@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Duthie wrote:
> I'm having a few Problems with a NEW PC
> 
> Spec is:
> Intel DQ35JOE Mainboard
> 
> The Integrated NIC is not found by kernel 2.6.23-rc6 or  2.6.22.1
> Am I missing an option in there ??

support for that nic has not yet been released as a -rc or stable kernel release

> The Intel Drivers (e1000-7.6.5)  don't compile against 2.6.23-rc6 or 2.6.22.1
> /usr/src/intel/e1000- 7.6.5/src/e1000_ethtool.c:2109: error:
> 'ethtool_op_get_perm_addr' undeclared here (not in a function)
> ( I know, wrong place to report this ...... )

deleting that 1 line should fix the compile issue

> ( also SATA dvd writer does not seem to write yet )
> 
> If anyone has Patches to try I'm Currently able and willing to test
> them on this hardware config!
> 
> see attached stuff
> mail me for more info if required !

A new driver will be available in 2 weeks, or you can use any of the git trees
that have the "e1000e" driver which sill support this device (davem/net-2.6.24 or
jgarzik/netdev-2.6@upstream)

Cheers,

Auke
