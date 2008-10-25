Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYJYXPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYJYXPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYJYXP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:15:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYJYXP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:15:28 -0400
Date: Sat, 25 Oct 2008 16:14:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Antonino Daplas <adaplas@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH RESEND] vgacon: remember scrollback buffer on console
 switch
Message-Id: <20081025161456.643b36c6.akpm@linux-foundation.org>
In-Reply-To: <20081025224247.GA25497@joi>
References: <20081025195814.GD10932@joi>
	<20081025134615.36f7285f.akpm@linux-foundation.org>
	<20081025224247.GA25497@joi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 00:43:01 +0200 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> PS: why DECLARE_MUTEX _defines_ _semaphore_?

The kernel gets definition-vs-declaration confused in several places.

> there are only 8 uses of this
> macro so it's not a big problem to rename it to e.g. DEFINE_SEMAPHORE (I can
> provide a patch)

I'd say that s/declare/define/ at such a late stage in the semaphore's
lifetime would be of dubious value.  But getting "MUTEX" out of that
macro's name would be a very good thing - it's a bad overlap with struct
mutex.  Send patch :)


