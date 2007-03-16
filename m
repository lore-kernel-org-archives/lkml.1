Return-Path: <linux-kernel-owner+w=401wt.eu-S965821AbXCPSWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965821AbXCPSWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965822AbXCPSWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:22:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:44683 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965821AbXCPSWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:22:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Guillaume Chazarain" <guichaz@gmail.com>
Subject: Re: [PATCH] Add an offset in the cyc2ns computation to fix sched_clock jumps
Date: Fri, 16 Mar 2007 19:22:12 +0100
User-Agent: KMail/1.9.5
Cc: "john stultz" <johnstul@us.ibm.com>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
References: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
In-Reply-To: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161922.13450.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 19:14, Guillaume Chazarain wrote:
> Hello,
> 
> The scheduling problems I reported in the thread:
> http://lkml.org/lkml/2007/3/3/128
> are caused by the set_cyc2ns_scale() function called when the CPU speed changes.
> Changing the scale causes a warp in the value returned by sched_clock().

I already fixed this myself in a similar way (but didn't push it out yet) 

But for .21 I ended up deciding on your revert patch, even though it will give bad
performance.

-Andi

