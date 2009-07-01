Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZGAOqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZGAOqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZGAOqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:46:23 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:45668 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZGAOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:46:22 -0400
Message-ID: <4A4B76BF.60006@in.ibm.com>
Date: Wed, 01 Jul 2009 20:16:23 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot failure
References: <20090701160014.595e1338.sfr@canb.auug.org.au> <1246451712.22562.38.camel@dhcp235-23.rdu.redhat.com>
In-Reply-To: <1246451712.22562.38.camel@dhcp235-23.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> I will check the makefiles to see if kernel/built-in.o is linked in
> before fs/buildin-in.o.  I don't see a reason why audit watches need to
> be that early in the kernel init process.  This isn't happening on my
> system so I'm asking if anyone hitting it can apply this patch and test?
>
> Audit: audit watch init should not be before fsnotify init
>
> From: Eric Paris <eparis@redhat.com>
With this patch i am able to boot today's next on my machines.

Tested-by : Sachin Sant <sachinp@in.ibm.com>

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

