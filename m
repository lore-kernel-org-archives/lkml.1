Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYDGMLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYDGMLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbYDGMLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:11:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49910 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYDGMLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:11:42 -0400
Date: Mon, 7 Apr 2008 14:16:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pavel Emelianov <xemul@openvz.org>,
       hugh@veritas.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Disable the memory controller by default
Message-ID: <20080407121600.GC16647@one.firstfloor.org>
References: <20080407115137.24124.59692.sendpatchset@localhost.localdomain> <20080407120340.GB16647@one.firstfloor.org> <47FA0D85.201@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FA0D85.201@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The boot control options apply to all controllers and we want to allow
> controllers to decide whether they should be turned on or off.

Ok that's fine too (to have finer grained options), just those should
be on/off too, not toggle.

> documentation support in Documentation/kernel-parameters.txt, don't you think we
> can expect this to work as the user intended?

Even with documentation support semantics changes over releases are not nice.
So "toggle" is bad, always have it absolute values.

So if an user decides they want full cgroup support and stick in a option
for .25 into their boot loader config they should always get full cgroup support in 
all future kernels.  Similiar if someone decides they don't need it. 

-Andi
