Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZKWQqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZKWQqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZKWQqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:46:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbZKWQqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:46:33 -0500
Subject: Re: [PATCH] perf_events: fix bogus copy_to_user() in
 perf_event_read_group()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, eranian@gmail.com, mingo@elte.hu,
       paulus@samba.org, perfmon2-devel@lists.sourceforge.net
In-Reply-To: <bd4cb8900911230836na261658udd82f5c20630ffba@mail.gmail.com>
References: <4b0ab8b1.1c07d00a.4859.5f71@mx.google.com>
	 <bd4cb8900911230836na261658udd82f5c20630ffba@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 17:46:20 +0100
Message-ID: <1258994780.4531.682.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 17:36 +0100, Stephane Eranian wrote:
>        When using an event group, the value and id for non leaders events were
>        wrong due to invalid offset into the outgoing buffer.
> 
>        Signed-off-by: Stephane Eranian <eranian@google.com>

Gah, I only just wrecked that didn't I...

Thanks for catching that.

