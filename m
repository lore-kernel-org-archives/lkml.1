Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZILEXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZILEXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 00:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZILEXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 00:23:49 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:60043 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbZILEXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 00:23:49 -0400
From: Frans Pop <elendil@planet.nl>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: bisect results of MSI-X related panic (help!)
Date: Sat, 12 Sep 2009 06:23:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
References: <1252699744.3877.15.camel@jbrandeb-hc.jf.intel.com>
In-reply-To: <1252699744.3877.15.camel@jbrandeb-hc.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909120623.49764.elendil@planet.nl>
X-OriginalArrivalTime: 12 Sep 2009 04:23:51.0082 (UTC) FILETIME=[D4A328A0:01CA3360]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Brandeburg wrote:
> I've bisected, here is my bisect log, problem is that the commit
> identified is a merge commit, and *I don't know what to revert to test*.
> It appears the parent of the merge:
> 6e15cf04860074ad032e88c306bea656bbdd0f22 is marked good, but looks to be
> in a possibly related area to the panic.

That merge does contain quite a few merge fixups, so it's quite possible 
one of them is the cause of the failure.
Maybe the simplest way to verify that is to compile both parents of the 
merge to doublecheck that they work OK. Then, if a compile of the merge 
itself is bad, the problem really is in the merge commit itself.

That commit is the "percpu" merge, so I've added Tejun (author of most of 
that branch) and Ingo (merger) in CC.

Hope that helps.

Cheers,
FJP
