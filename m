Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbZFWW7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbZFWW7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbZFWW7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:59:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41168 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759079AbZFWW7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:59:24 -0400
Date: Tue, 23 Jun 2009 21:44:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com
Subject: Re: [RFC] tcp: race in receive part
Message-ID: <20090623194449.GB28836@redhat.com>
References: <20090618102727.GC3782@jolsa.lab.eng.brq.redhat.com> <4A3A49F2.6060705@gmail.com> <20090623091257.GA4850@jolsa.lab.eng.brq.redhat.com> <4A40AF2A.3050509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40AF2A.3050509@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Off-topic)

On 06/23, Eric Dumazet wrote:
>
> The optimization we could do, defining
> a smp_mb_after_read_lock() that could be a nop on x86

Imho it would be nice to have smp_mb__before/after_lock.

insert_work(), __pte_alloc(), try_to_wake_up() could use it. Probably
something else.

Oleg.

