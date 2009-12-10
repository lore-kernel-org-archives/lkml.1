Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbZLJR72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbZLJR72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761352AbZLJR70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:59:26 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:53722 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761350AbZLJR7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:59:25 -0500
Date: Thu, 10 Dec 2009 11:59:11 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 4/5] add a lowmem check function
In-Reply-To: <20091210170036.dde2c147.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912101155490.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com> <20091210170036.dde2c147.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, KAMEZAWA Hiroyuki wrote:

> This patch adds an integer lowmem_zone, which is initialized to -1.
> If zone_idx(zone) <= lowmem_zone, the zone is lowmem.

There is already a policy_zone in mempolicy.h. lowmem is if the zone
number is  lower than policy_zone. Can we avoid adding another zone
limiter?


