Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZHLD5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZHLD5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 23:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZHLD5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 23:57:44 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36502 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZHLD5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 23:57:43 -0400
Date: Wed, 12 Aug 2009 09:27:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       kosaki.motohiro@jp.fujitsu.com, menage@google.com, prarit@redhat.com,
       andi.kleen@intel.com, xemul@openvz.org, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Help Resource Counters Scale better (v4)
Message-ID: <20090812035740.GG7176@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090811144405.GW7176@balbir.in.ibm.com> <20090811163159.ddc5f5fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090811163159.ddc5f5fd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-08-11 16:31:59]:

> Is this an alternative approach to using percpu_counters, or do we do
> both or do we choose one or the other?  res_counter_charge() really is
> quite sucky.
>

This is an alternative approach, I'll still do the percpu counter
patches, but once the overhead for root is gone, most users not using
this functionality will not see any major overhead. 

-- 
	Balbir
