Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYAEKAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYAEKAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 05:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYAEKAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 05:00:10 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46629 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYAEKAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 05:00:09 -0500
Date: Sat, 5 Jan 2008 11:59:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, olof@lixom.net, mpm@selenic.com
Subject: Re: [patch 1/2] move WARN_ON() out of line
Message-ID: <20080105095940.GB2304@does.not.exist>
References: <477D52ED.7000403@linux.intel.com> <20080104074149.GC17447@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080104074149.GC17447@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 08:41:49AM +0100, Ingo Molnar wrote:
>...
> i'm wondering how we could put this into x86.git to get it tested some 
> more.
>...

Please don't make x86.git a testing tree for not x86 specific stuff.

The right place for getting stuff tested is -mm, and when looking at 
git-x86.patch in -mm this tree already touches too many files outside
of arch/x86/ and include/asm-x86/.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

