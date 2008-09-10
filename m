Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYIJXcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYIJXcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYIJXcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:32:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbYIJXcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:32:39 -0400
Date: Wed, 10 Sep 2008 16:31:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: linux-kernel@vger.kernel.org, aabdulla@nvidia.com, jgarzik@pobox.com
Subject: Re: forcedeth: option to disable 100Hz timer (try 2)
Message-Id: <20080910163141.e0a36f3f.akpm@linux-foundation.org>
In-Reply-To: <20080909233435.7eafede1@laska>
References: <20080909233435.7eafede1@laska>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 23:34:35 +0400
Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:

> 
> On some hardware no TX done interrupts are generated, thus special
> 100Hz timer interrupt is required to handle this situation properly.
> Other device do not require that timer interrupt feature. 
> 
> Forcedeth has a DEV_NEED_TIMERIRQ flag to mark the broken devices.
> Unfortunately, nobody know the actual list of broken devices, so all
> device has this flag on. Other problem, this flag is not user visible,
> so the kernel recompilation is required to disable timer interrupts and
> test a device.
> 
> This patch add a "disable_timerirq" option to disable interrupt 
> timer mentioned above. This may be extremely useful for laptop users.

Why do you feel that the timer-based completions need to be disabled? 
Is it causing some problem?
