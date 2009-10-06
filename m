Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbZJFKLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbZJFKLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZJFKLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:11:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59421 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbZJFKLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:11:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH][RFC] add MAP_UNLOCKED mmap flag
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
In-Reply-To: <20091006095111.GG9832@redhat.com>
References: <20091006095111.GG9832@redhat.com>
Message-Id: <20091006190938.126F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Oct 2009 19:11:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> If application does mlockall(MCL_FUTURE) it is no longer possible to
> mmap file bigger than main memory or allocate big area of anonymous
> memory. Sometimes it is desirable to lock everything related to program
> execution into memory, but still be able to mmap big file or allocate
> huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
> allows to do that.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>

Why don't you use explicit munlock()?
Plus, Can you please elabrate which workload nedd this feature?



