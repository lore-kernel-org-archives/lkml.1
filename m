Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbZE2QKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbZE2QKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760533AbZE2QKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:10:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51044 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759210AbZE2QKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:10:39 -0400
Message-ID: <4A2008F0.1070304@redhat.com>
Date: Fri, 29 May 2009 12:10:24 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [1/16] HWPOISON: Add page flag for poisoned pages
References: <200905271012.668777061@firstfloor.org> <20090527201226.CCCBB1D028F@basil.firstfloor.org> <20090527221510.5e418e97@lxorguk.ukuu.org.uk> <20090528075416.GY1065@one.firstfloor.org>
In-Reply-To: <20090528075416.GY1065@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, May 27, 2009 at 10:15:10PM +0100, Alan Cox wrote:
>> On Wed, 27 May 2009 22:12:26 +0200 (CEST)
>> Andi Kleen <andi@firstfloor.org> wrote:
>>
>>> Hardware poisoned pages need special handling in the VM and shouldn't be 
>>> touched again. This requires a new page flag. Define it here.
>> Why can't you use PG_reserved ? That already indicates the page may not
>> even be present (which is effectively your situation at that point).
> 
> Right now a page must be present with PG_reserved, otherwise /dev/mem, /proc/kcore
> lots of other things will explode.

Could we use a combination of, say PG_reserved and
PG_writeback to keep /dev/mem and /proc/kcore from
exploding ?

-- 
All rights reversed.
