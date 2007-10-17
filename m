Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXJQMEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXJQMEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbXJQMEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:04:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57496 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757674AbXJQMEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:04:22 -0400
Date: Wed, 17 Oct 2007 05:04:16 -0700
From: Paul Jackson <pj@sgi.com>
To: ego@in.ibm.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, rusty@rustcorp.com.au,
       dipankar@in.ibm.com, oleg@tv-sign.ru, mingo@elte.hu, paulmck@us.ibm.com
Subject: Re: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Message-Id: <20071017050416.a3ecdc43.pj@sgi.com>
In-Reply-To: <20071017115047.GD9940@in.ibm.com>
References: <20071016103308.GA9907@in.ibm.com>
	<20071016103417.GA16570@in.ibm.com>
	<20071017035327.ff1ed622.pj@sgi.com>
	<20071017042709.02525cbd.pj@sgi.com>
	<20071017115047.GD9940@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham wrote:
> Thanks for the patch! 

You're welcome.

I wonder what are the chances of this patch set making it into 2.6.24.

The cgroup (aka container) folks Paul Menage and David Rientjes are
working with me on the (hopefully) last fix for getting cpusets to work
with the cgroup changes.  This involves how cpusets adapts to CPUs
coming and going from the system due to hotplug/hotunplug or coming and
going from cpusets due to user changes in the cpuset configuraton.

Not surprisingly, the code we are struggling with depends on the CPU
hotplug support, and this present patch set of yours looks to be a
fine improvement to that.

However whatever we do for this last fix has to make it into 2.6.24,
because cgroups themselves are targeted for 2.6.24, and I can't let
that lead to any serious regressions in existing cpuset capability.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
