Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196Ab0A1Oov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0A1Oov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 09:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001Ab0A1Oou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 09:44:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0A1Oou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 09:44:50 -0500
Subject: Re: [PATCH] perf: Add util/include/linux/config.h for including
 generated autoconf.h of kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1264688928-12861-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <4B6133DF.9080207@dcl.info.waseda.ac.jp>
	 <1264688928-12861-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 15:44:38 +0100
Message-ID: <1264689878.4283.2101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 23:28 +0900, Hitoshi Mitake wrote:
> I'd like to add util/include/linux/config.h,
> this header file includes autoconf.h which is generated
> by build phase of kernel.
> 
> This makes building of perf depend on building of kernel.
> It's a little dirty. But perf has tight relation
> of its kernel, so I don't think that it is a serious problem.
> 
> My original purpose of making this patch is
> knowing size of void *.
> If config.h is available,
> CONFIG_ARCH_PHYS_ADDR_T_64BIT will be provided for source of perf,
> we can know size of void * by this config.
> 
> How do you think?

I think sizeof(void *).

