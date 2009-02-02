Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbZBBWzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbZBBWzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZBBWzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:55:11 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:50996 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZBBWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:55:10 -0500
Message-ID: <498779C2.2060908@nortel.com>
Date: Mon, 02 Feb 2009 16:54:58 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
CC: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: cgroup mount point
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com>
In-Reply-To: <20090202214153.GV3643@vespa.holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2009 22:55:02.0585 (UTC) FILETIME=[483EAA90:01C98589]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thadeu Lima de Souza Cascardo wrote:

> Linux Documentation is not consistent and have some funny options. In
> Documentation/cgroups/*, we have:

> So, we have some more options now: /cgroups, /containers, /dev/cpuset,
> /dev/cpuctl, /opt/cgroup, /opt/cpuset.
> 
> I am copying the container and the kernel guys. Perhaps, we can find an
> agreement (if we want to find one at all) and change all that
> Documentation to get consistent.

I'd vote for "cgroups" or "containers", mounted at / or /sys/.

/opt feels more like where software should live, and /dev should be for 
devices rather than capabilities/management.  "cpuctl" and "cpuset" are 
subsets of the full capabilities of cgroups, so they're suboptimal as 
far as naming.

Chris
