Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0BEOrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:47:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:41868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab0BEOrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:47:20 -0500
Subject: Re: [PATCH 0/4] correct onstack wait_queue_head declaration
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
References: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 15:47:11 +0100
Message-ID: <1265381231.22001.673.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 21:52 +0800, Yong Zhang wrote:
> Onstack wait_queue_head must be declared with
> DECLARE_WAIT_QUEUE_HEAD_ONSTACK. Otherwise it will make lockdep
> warn. So fix the wrong usage in this patchset.
> 
> BTW, I split it to 4 patches to send to different maintainer
> though it's due to the same issue. If you have no objection
> on this kind of fix, I can also send it in one patch for some
> simplification.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

--no-chain-reply-to

