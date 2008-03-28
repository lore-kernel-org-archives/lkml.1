Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYC1QHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYC1QHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYC1QHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:07:37 -0400
Received: from gw.goop.org ([64.81.55.164]:53680 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYC1QHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:07:36 -0400
Message-ID: <47ED17AF.5030804@goop.org>
Date: Fri, 28 Mar 2008 09:07:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0 of 4] [RFC] hotplug memory: minor updates
References: <patchbomb.1206664116@localhost> <20080328091250.GH21413@elte.hu>
In-Reply-To: <20080328091250.GH21413@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> the x86 bits look small and trivial, so i'd suggest you get this into 
> -mm to after all the other VM patches, because this seems primarily a VM 
> issue.
>   

I would do that, but I'm planning on posting some Xen balloon driver 
patches which depend on at least one of these patches.

I'll drop "hotplug-memory: adding non-section-aligned memory is bad" 
because it was just warnings and it was NACKed.  "hotplug-memory: add 
add_memory_resource()" is just a refactor, and should be a noop as far 
as the existing add_memory() is concerned.


> i've applied #3 to x86.git straight away. Does #4 have dependencies on 
> the other patches? I suspect it does so it cannot be applied standalone.
>   

You mean the "paravirt_ops: don't steal memory resources in 
paravirt_disable_iospace"?  That shouldn't have any dependencies.  It's 
the only patch in my queue which even references that file.  Rusty said 
he picked it up too; are you exchanging patches with him?

    J
