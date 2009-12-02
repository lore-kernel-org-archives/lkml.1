Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZLBTEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZLBTEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZLBTED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:04:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZLBTEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:04:02 -0500
Subject: Re: some recent scheduler patches
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20091202185328.GI31517@wotan.suse.de>
References: <20091202185328.GI31517@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 20:04:02 +0100
Message-ID: <1259780642.4003.1493.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 19:53 +0100, Nick Piggin wrote:
> 
> 
> 83f54960c11a14942ab00b54c51e91906b9d8235: sched: for_each_domain() vs RCU
> I don't see what is the step that causes FAIL? sched-domains code is
> using synchronize_sched(), so that part should be safe.

Yeah, I got myself properly confused there. I was meaning to remove that
rcu_read_lock() there again.

