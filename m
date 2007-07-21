Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbXGUGOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbXGUGOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXGUGNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:13:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbXGUGNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:13:52 -0400
Date: Fri, 20 Jul 2007 23:13:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] compacting file_ra_state
In-Reply-To: <20070721055706.GA5097@one.firstfloor.org>
Message-ID: <alpine.LFD.0.999.0707202312260.27249@woody.linux-foundation.org>
References: <20070721035733.951838089@mail.ustc.edu.cn>
 <20070721035850.977231489@mail.ustc.edu.cn> <384990797.09024@ustc.edu.cn>
 <alpine.LFD.0.999.0707202126250.27249@woody.linux-foundation.org>
 <20070721055706.GA5097@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Jul 2007, Andi Kleen wrote:
> 
> Haven't the readahead patches already essentially been in -mm* for some time?

They have indeed, and I merged them this week.

> I thought the new patches were some some restructured code, but 
> essentially the tested algorithms?

No, this series is a further cleanup on top of the restructured code, with 
some new features too. The series _looks_ fine to me, but it still makes 
sense to go through -mm, I think.

		Linus
