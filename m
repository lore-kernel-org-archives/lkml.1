Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbZIOXzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbZIOXzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZIOXz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:55:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51775 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZIOXz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:55:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Sep 2009 08:53:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm on powerpc: walk_memory_resource?
Message-Id: <20090916085323.01f828a3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0909152224400.29857@sister.anvils>
References: <Pine.LNX.4.64.0909152224400.29857@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 22:36:26 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> Recent mmotm builds on powerpc have been failing with
> 
> arch/powerpc/mm/mem.c:169: error: ‘walk_memory_resource’ undeclared here (not in a function)
> cc1: warnings being treated as errors
> arch/powerpc/mm/mem.c:169: error: type defaults to ‘int’ in declaration of ‘walk_memory_resource’
> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
> 
> because walk-system-ram-range.patch renames walk_memory_resource()
> but leaves the EXPORT_SYMBOL_GPL(walk_memory_resource).  I couldn't
> tell from the patch description whether it's a matter of changing
> the EXPORT_SYMBOL_GPL or removing the patch to arch/powerpc/mm/mem.c
> or something else.  (I change the EXPORT to get my build working,
> but there appears to be something in drivers/infiniband which still
> wants a walk_memory_resource.)
> 

Very sorry..my mistake. Will fix it immedieately.

-Kame

> Hugh

