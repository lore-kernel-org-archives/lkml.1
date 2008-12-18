Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753453AbYLRMun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYLRMun (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYLRMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:50:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbYLRMua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:50:30 -0500
Date: Thu, 18 Dec 2008 13:50:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_buffer: remove unused ring_buffer size
Message-ID: <20081218125014.GA32135@elte.hu>
References: <4948CAE7.107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4948CAE7.107@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0155]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> struct ring_buffer.size is not set after ring_buffer is initialized
> or resized. it is always 0.
> 
> we can use "buffer->pages * BUF_PAGE_SIZE" to get ring_buffer's size
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

applied to tip/tracing/ring-buffer, thanks!

	Ingo
