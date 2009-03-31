Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbZCaOXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbZCaOXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZCaOWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:22:55 -0400
Received: from gate.eia.be ([194.78.71.18]:26664 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZCaOWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:22:54 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 10:22:54 EDT
Date: Tue, 31 Mar 2009 16:07:34 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
Message-ID: <20090331140733.GF6321@e-circ.dyndns.org>
References: <20090324154617.GA16332@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090324154617.GA16332@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 31 Mar 2009 14:11:36.0926 (UTC) FILETIME=[9A8F27E0:01C9B20A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My idea as a user, having configured some servers:

On Tue, Mar 24, 2009 at 05:46:17PM +0200, Matt Domsch wrote:
> 
> Problem:  Users expect on-motherboard NICs to be named eth0..ethN.  This can be difficult to achieve.

with kernel point of view, there should be no preference. If users
expect some numbering, I believe udev provides all the tools.
> 
> Ethernet device names are initially assigned by the kernel, and may be
> changed by udev or nameif in userspace.  The initial name assigned by
> the kernel is in monotonically increasing order, starting with eth0.
> In this instance, the enumeration directly leads to an assigned name.
the problem here is the monotonic increasing order. I never rename ethX
back to the monotonic ethX numbering. IMHO, renaming eth0 to eth1 sounds
redundant.
I rename ethx to lan, wan, wlan, remote, lan0, lan1, ...
This naming _cannot_ conflict.
> 
> 
>       To ease this complication, SMBIOS 2.6 includes a mechanism for
>       BIOS to specify its expected ordering of devices, for naming
>       purposes.  Tools such as biosdevname use this information.
I'd preferrably not rely on bios tools, not every system has a (stable) bios.
> 
> 

