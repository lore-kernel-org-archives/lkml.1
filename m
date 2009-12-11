Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZLKNfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZLKNfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZLKNfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:35:46 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:39194 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZLKNfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:35:45 -0500
Date: Fri, 11 Dec 2009 07:35:02 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Lee.Schermerhorn@hp.com
Subject: Re: [RFC mm][PATCH 4/5] add a lowmem check function
In-Reply-To: <20091211093938.70214f9c.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912110733310.30295@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com> <20091210170036.dde2c147.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0912101155490.5481@router.home> <20091211093938.70214f9c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009, KAMEZAWA Hiroyuki wrote:

> Hmm, How about adding following kind of patch after this
>
> #define policy_zone (lowmem_zone + 1)
>
> and remove policy_zone ? I think the name of "policy_zone" implies
> "this is for mempolicy, NUMA" and don't think good name for generic use.

Good idea but lets hear Lee's opinion about this one too.
