Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYB2MD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYB2MD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYB2MDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:03:18 -0500
Received: from mail.amln.net ([88.203.210.2]:33076 "EHLO neon.bastun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbYB2MDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:03:17 -0500
X-Greylist: delayed 1537 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 07:03:17 EST
Message-ID: <47C7EEAC.7010907@amln.net>
Date: Fri, 29 Feb 2008 13:38:20 +0200
From: Xpl++ <xpl@amln.net>
User-Agent: Mozilla Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Linux Containers <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelianov <xemul@openvz.org>, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
In-Reply-To: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage ??????:
> ...
>
> A compromise might be to keep "tasks" unprefixed, and say that future
> names get the "cgroup." prefix; in this case I'd be inclined to add
> the prefix to notify_on_release and release_agent on the grounds that
> there's much less chance of breaking anyone with those files since (I
> suspect) they're much less used.
>   
This makes most sense to me. It won't break any existing software (most 
likely) while it seems reasonable to leave 'tasks' unprefixed as this is 
something that any software using any subsystem of cgroup would be using 
anyway and it is not that much associated with a particulat subsystem.

Regards,
Peter Litov.
