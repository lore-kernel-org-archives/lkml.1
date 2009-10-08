Return-Path: <linux-kernel-owner+w=401wt.eu-S1759740AbZJHXSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbZJHXSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZJHXSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:18:53 -0400
Received: from ozlabs.org ([203.10.76.45]:59426 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078AbZJHXSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:18:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19150.24403.892990.320696@cargo.ozlabs.ibm.com>
Date: Fri, 9 Oct 2009 08:53:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing: Check total refcount before releasing
	bufs in profile_enable failure
In-Reply-To: <20091008214258.GH5073@nowhere>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
	<1254577650-5623-2-git-send-email-fweisbec@gmail.com>
	<19148.1579.573095.98045@cargo.ozlabs.ibm.com>
	<20091008214258.GH5073@nowhere>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> No, because now we only increment total_profile_count if
> nothing has failed. This is even the last thing done
> in the succeeded path. So if we fail and need to free, it
> means its values is still 0.

Ah yes, good point.

Paul.
