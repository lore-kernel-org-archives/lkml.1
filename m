Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYGRQ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYGRQ1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbYGRQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:26:54 -0400
Received: from [208.74.158.172] ([208.74.158.172]:54603 "EHLO ns3.lanforge.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbYGRQ0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:26:53 -0400
X-Greylist: delayed 2507 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 12:26:53 EDT
Message-ID: <4880BA7A.3020909@candelatech.com>
Date: Fri, 18 Jul 2008 08:44:58 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG, NET] deadlock tearing down a bridged interface
References: <20080718073724.GA5802@disturbed>
In-Reply-To: <20080718073724.GA5802@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> Folks,
>
> I just deadlocked networking on a 2.6.24 kernel. Basically I
> was trying to restart the bridge interface I use for UML sessions
> because it wasn't passing packets. This happens occasionally
> when I leave a UML session too long in gdb, so I bounced the
> bridge to get it working again.
>   
We have been chasing a refcount bug in 2.6.25 that only happens when
IPv6 module is loaded.  If you are not actually using ipv6, try removing 
it's
module from your /lib/modules/* directory and see if that fixes your 
problem.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


