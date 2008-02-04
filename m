Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYBDXZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYBDXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYBDXZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:25:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748AbYBDXZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:25:16 -0500
Date: Mon, 4 Feb 2008 15:25:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       netdev@vger.kernel.org
Subject: Re: 2.6.24-mm1 - Build failure at net/sched/cls_flow.c:598
Message-Id: <20080204152505.62b2b8b5.akpm@linux-foundation.org>
In-Reply-To: <47A79291.5010204@imap.cc>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	<47A79291.5010204@imap.cc>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 23:32:49 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> My attempt to build this failed with:
> 
>    CC [M]  net/sched/cls_flow.o
> net/sched/cls_flow.c: In function ___flow_dump___:
> net/sched/cls_flow.c:598: error: ___struct tcf_ematch_tree___ has no member named ___hdr___
> 
> Config attached.

Thanks.  hm.

	#else /* CONFIG_NET_EMATCH */

	struct tcf_ematch_tree
	{
	};

methinks Patrick has a CONFIG_NET_EMATCH=n problem?
