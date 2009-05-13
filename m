Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbZEMOtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbZEMOtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZEMOtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:49:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60101 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbZEMOtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:49:21 -0400
Message-ID: <4A0ADD88.9080705@redhat.com>
Date: Wed, 13 May 2009 10:47:36 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120729.5885.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090513120729.5885.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Subject: [PATCH] zone_reclaim_mode is always 0 by default
> 
> Current linux policy is, if the machine has large remote node distance,
>  zone_reclaim_mode is enabled by default because we've be able to assume to 
> large distance mean large server until recently.
> 
> Unfrotunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P transport
> memory controller. IOW it's NUMA from software view.
> 
> Some Core i7 machine has large remote node distance and zone_reclaim don't
> fit desktop and small file server. it cause performance degression.
> 
> Thus, zone_reclaim == 0 is better by default. sorry, HPC gusy. 
> you need to turn zone_reclaim_mode on manually now.

I'll believe that it causes a performance regression with the
old zone_reclaim behaviour, however the way you tweaked
zone_reclaim should make it behave a lot better, no?

-- 
All rights reversed.
