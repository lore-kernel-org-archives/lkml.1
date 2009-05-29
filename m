Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbZE2Qhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbZE2Qhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbZE2Qh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:37:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46314 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbZE2Qh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:37:27 -0400
Message-ID: <4A200F40.9050703@redhat.com>
Date: Fri, 29 May 2009 12:37:20 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: fengguang.wu@intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [2/16] HWPOISON: Export poison flag in /proc/kpageflags
References: <200905271012.668777061@firstfloor.org> <20090527201227.EAEC41D0286@basil.firstfloor.org>
In-Reply-To: <20090527201227.EAEC41D0286@basil.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Fengguang Wu <fengguang.wu@intel.com>
> 
> Export the new poison flag in /proc/kpageflags. Poisoned pages are moderately
> interesting even for administrators, so export them here. Also useful
> for debugging.
> 
> AK: I extracted this out of a larger patch from Fengguang Wu.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

OK, this could be a good reason for the use of the PG_poisoned page
flag in patch 1/16.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
