Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbXESLfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbXESLfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 07:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXESLfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 07:35:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47710 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbXESLfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 07:35:05 -0400
Date: Sat, 19 May 2007 13:35:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
Message-ID: <20070519113501.GB25563@one.firstfloor.org>
References: <20070516224752.500812933@mail.ustc.edu.cn> <379355695.83536@ustc.edu.cn> <20070518232824.9917d794.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518232824.9917d794.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We have the advantage that if the kernel very occasionally gets the wrong
> result for PageReadahead(page), nothing particularly bad will happen, so we
> can do racy things.
 
On 64bit there is no particular shortage of page flags. If you ever do
racy things please do them 32bit only.

-Andi

