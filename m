Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbYKZBKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbYKZBKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYKZBKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:10:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753866AbYKZBKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:10:14 -0500
Date: Tue, 25 Nov 2008 17:09:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [PATCH] random: add a way to get some random bits into the
 entropy pools early on
Message-Id: <20081125170923.40881182.akpm@linux-foundation.org>
In-Reply-To: <20081125132600.5112fb24@infradead.org>
References: <20081125132600.5112fb24@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 13:26:00 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> currently the entropy pool gets seeded on the module_init() level, but there
> is at least one consumer of random bits (the oops ID that is printed as part
> of the oops).

There seems to be some missing text here.

> As a result of this, kerneloops.org is seeing a lot of oopses that all share
> the same 'random' number; which used to get filed away as "duplicate".
> 
> This patch adds a function to the random driver so that various pieces of
> the kernel can add random bits (but not entropy!) to the pool, to avoid
> this dupicate ID problem.
