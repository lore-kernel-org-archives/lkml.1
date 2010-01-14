Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724Ab0ANAbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0ANAbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346Ab0ANAbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:31:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42198 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0ANAbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:31:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20100113093119.GT7549@redhat.com>
References: <20100113093119.GT7549@redhat.com>
Message-Id: <20100114092845.D719.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 09:31:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If application does mlockall(MCL_FUTURE) it is no longer possible to mmap
> file bigger than main memory or allocate big area of anonymous memory
> in a thread safe manner. Sometimes it is desirable to lock everything
> related to program execution into memory, but still be able to mmap
> big file or allocate huge amount of memory and allow OS to swap them on
> demand. MAP_UNLOCKED allows to do that.
>  
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> ---
> 
> I get reports that people find this useful, so resending.

This description is still wrong. It doesn't describe why this patch is useful.



