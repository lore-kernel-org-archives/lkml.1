Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZEMNha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZEMNha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZEMNhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:37:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZEMNhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:37:14 -0400
Message-ID: <4A0ACCAA.4020505@redhat.com>
Date: Wed, 13 May 2009 09:35:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/4] vmscan: drop PF_SWAPWRITE from zone_reclaim
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120627.587F.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090513120627.587F.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Subject: [PATCH] vmscan: drop PF_SWAPWRITE from zone_reclaim
> 
> PF_SWAPWRITE mean ignore write congestion. (see may_write_to_queue())
> 
> foreground reclaim shouldn't ignore it because to write congested device cause
> large IO lantency.
> it isn't better than remote node allocation.

It might be on NUMAQ (which is no longer manufactured), but
your change looks right for every other vaguely modern NUMA
architecture that I know of.

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
